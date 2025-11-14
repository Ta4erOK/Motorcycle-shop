using MotorcycleShop.Domain.Entities;
using MotorcycleShop.Domain.Interfaces;
using MotorcycleShop.Domain.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
using System.Windows.Controls;

namespace MotorcycleShop.UI
{
    public partial class MainWindow : Window
    {
        private IMotorcycleRepository _motorcycleRepository;
        private IShoppingCartRepository _cartRepository;

        private List<Motorcycle> _currentMotorcycles;

        //(в реальном приложении генерировался бы уникальный)
        private string _sessionId = "user-session-001";

        public MainWindow()
        {
            InitializeComponent();

            _motorcycleRepository = new MotorcycleRepository();
            _cartRepository = new ShoppingCartRepository();

            LoadMotorcycles();
            LoadFilters();
            UpdateCartCount();

            SearchTextBox.Text = "Введите марку, модель или описание...";
            SearchTextBox.Foreground = System.Windows.Media.Brushes.Gray;
        }

        private void LoadMotorcycles()
        {
            try
            {
                _currentMotorcycles = _motorcycleRepository.GetAll();

                MotorcyclesDataGrid.ItemsSource = _currentMotorcycles;

                UpdateStatus($"Загружено {_currentMotorcycles.Count} мотоциклов");
                UpdateCount();
            }
            catch (Exception ex)
            {
                ShowError($"Ошибка при загрузке мотоциклов: {ex.Message}");
            }
        }

        private void LoadFilters()
        {
            try
            {
                var brands = _motorcycleRepository.GetAllBrands();
                BrandFilterComboBox.ItemsSource = new List<string> { "Все марки" }.Concat(brands);
                BrandFilterComboBox.SelectedIndex = 0;

                var years = _motorcycleRepository.GetAllYears();
                YearFilterComboBox.ItemsSource = new List<string> { "Все года" }.Concat(years.Select(y => y.ToString()));
                YearFilterComboBox.SelectedIndex = 0;
            }
            catch (Exception ex)
            {
                ShowError($"Ошибка при загрузке фильтров: {ex.Message}");
            }
        }

        private void ApplyFilters()
        {
            try
            {
                var filtered = _motorcycleRepository.GetAll();

                var searchText = SearchTextBox.Text;
                if (!string.IsNullOrWhiteSpace(searchText) && searchText != "Введите марку, модель или описание...")
                {
                    filtered = _motorcycleRepository.Search(searchText);
                }

                var selectedBrand = BrandFilterComboBox.SelectedItem as string;
                if (selectedBrand != null && selectedBrand != "Все марки")
                {
                    filtered = filtered.Where(m => m.Brand == selectedBrand).ToList();
                }

                var selectedYear = YearFilterComboBox.SelectedItem as string;
                if (selectedYear != null && selectedYear != "Все года" && int.TryParse(selectedYear, out int year))
                {
                    filtered = filtered.Where(m => m.Year == year).ToList();
                }

                _currentMotorcycles = filtered;
                MotorcyclesDataGrid.ItemsSource = _currentMotorcycles;

                UpdateStatus($"Найдено {_currentMotorcycles.Count} мотоциклов");
                UpdateCount();
            }
            catch (Exception ex)
            {
                ShowError($"Ошибка при применении фильтров: {ex.Message}");
            }
        }

        private void UpdateCartCount()
        {
            try
            {
                var cart = _cartRepository.GetBySessionId(_sessionId);
                int itemCount = cart?.Items.Sum(item => item.Quantity) ?? 0;
                CartButton.Content = $"Корзина ({itemCount})";
            }
            catch (Exception ex)
            {
                ShowError($"Ошибка при обновлении корзины: {ex.Message}");
            }
        }

        private void UpdateStatus(string message)
        {
            StatusTextBlock.Text = message;
        }

        private void UpdateCount()
        {
            CountTextBlock.Text = $"Количество: {_currentMotorcycles.Count}";
        }

        private void ShowError(string message)
        {
            MessageBox.Show(message, "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            UpdateStatus("Произошла ошибка");
        }


        private void SearchButton_Click(object sender, RoutedEventArgs e)
        {
            ApplyFilters();
        }

        private void SearchTextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            // ApplyFilters();
        }

        private void FilterComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            ApplyFilters();
        }

        private void ResetFiltersButton_Click(object sender, RoutedEventArgs e)
        {
            SearchTextBox.Text = "Введите марку, модель или описание...";
            SearchTextBox.Foreground = System.Windows.Media.Brushes.Gray;
            BrandFilterComboBox.SelectedIndex = 0;
            YearFilterComboBox.SelectedIndex = 0;
            LoadMotorcycles(); 
        }

        private void CartButton_Click(object sender, RoutedEventArgs e)
        {
            MessageBox.Show("Функционал корзины будет реализован ",
                          "В разработке",
                          MessageBoxButton.OK,
                          MessageBoxImage.Information);
        }

        private void MotorcyclesDataGrid_MouseDoubleClick(object sender, System.Windows.Input.MouseButtonEventArgs e)
        {
            if (MotorcyclesDataGrid.SelectedItem is Motorcycle selectedMotorcycle)
            {
                MessageBox.Show($"Детали мотоцикла:\n{selectedMotorcycle.Brand} {selectedMotorcycle.Model}\n" +
                               $"Год: {selectedMotorcycle.Year}\n" +
                               $"Цена: {selectedMotorcycle.Price:C}\n" +
                               $"Описание: {selectedMotorcycle.Description}",
                               "Детали мотоцикла",
                               MessageBoxButton.OK,
                               MessageBoxImage.Information);
            }
        }

        private void AddToCartButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (sender is Button button && button.Tag is int motorcycleId)
                {
                    _cartRepository.AddItemToCart(_sessionId, motorcycleId);

                    UpdateCartCount();

                    var motorcycle = _motorcycleRepository.GetById(motorcycleId);
                    if (motorcycle != null)
                    {
                        MessageBox.Show($"Мотоцикл {motorcycle.Brand} {motorcycle.Model} добавлен в корзину!",
                                      "Успешно",
                                      MessageBoxButton.OK,
                                      MessageBoxImage.Information);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError($"Ошибка при добавлении в корзину: {ex.Message}");
            }
        }
    }
}