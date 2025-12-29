import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

/// Модель страны с кодом
class Country {
  final String name;
  final String code;
  final String dialCode;
  final String flag;

  const Country({
    required this.name,
    required this.code,
    required this.dialCode,
    required this.flag,
  });
}

/// Список популярных стран
const List<Country> _countries = [
  Country(name: 'Россия', code: 'RU', dialCode: '+7', flag: '🇷🇺'),
  Country(name: 'Украина', code: 'UA', dialCode: '+380', flag: '🇺🇦'),
  Country(name: 'Беларусь', code: 'BY', dialCode: '+375', flag: '🇧🇾'),
  Country(name: 'Казахстан', code: 'KZ', dialCode: '+7', flag: '🇰🇿'),
  Country(name: 'США', code: 'US', dialCode: '+1', flag: '🇺🇸'),
  Country(name: 'Великобритания', code: 'GB', dialCode: '+44', flag: '🇬🇧'),
  Country(name: 'Германия', code: 'DE', dialCode: '+49', flag: '🇩🇪'),
  Country(name: 'Франция', code: 'FR', dialCode: '+33', flag: '🇫🇷'),
  Country(name: 'Италия', code: 'IT', dialCode: '+39', flag: '🇮🇹'),
  Country(name: 'Испания', code: 'ES', dialCode: '+34', flag: '🇪🇸'),
  Country(name: 'Польша', code: 'PL', dialCode: '+48', flag: '🇵🇱'),
  Country(name: 'Турция', code: 'TR', dialCode: '+90', flag: '🇹🇷'),
  Country(name: 'Китай', code: 'CN', dialCode: '+86', flag: '🇨🇳'),
  Country(name: 'Япония', code: 'JP', dialCode: '+81', flag: '🇯🇵'),
  Country(name: 'Корея', code: 'KR', dialCode: '+82', flag: '🇰🇷'),
  Country(name: 'Индия', code: 'IN', dialCode: '+91', flag: '🇮🇳'),
  Country(name: 'Бразилия', code: 'BR', dialCode: '+55', flag: '🇧🇷'),
  Country(name: 'Канада', code: 'CA', dialCode: '+1', flag: '🇨🇦'),
  Country(name: 'Австралия', code: 'AU', dialCode: '+61', flag: '🇦🇺'),
  Country(name: 'ОАЭ', code: 'AE', dialCode: '+971', flag: '🇦🇪'),
  Country(name: 'Грузия', code: 'GE', dialCode: '+995', flag: '🇬🇪'),
  Country(name: 'Армения', code: 'AM', dialCode: '+374', flag: '🇦🇲'),
  Country(name: 'Азербайджан', code: 'AZ', dialCode: '+994', flag: '🇦🇿'),
  Country(name: 'Узбекистан', code: 'UZ', dialCode: '+998', flag: '🇺🇿'),
];

/// Поле ввода телефона с выбором страны
class PhoneInputField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onFullPhoneChanged;
  final String? hintText;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.onFullPhoneChanged,
    this.hintText,
  });

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  late Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = _detectCountry();
    widget.controller.addListener(_onPhoneChanged);
  }

  /// Определяем страну по локали устройства
  Country _detectCountry() {
    final locale = ui.PlatformDispatcher.instance.locale;
    final countryCode = locale.countryCode?.toUpperCase() ?? 'RU';

    return _countries.firstWhere(
      (c) => c.code == countryCode,
      orElse: () => _countries.first, // По умолчанию Россия
    );
  }

  void _onPhoneChanged() {
    final fullPhone = '${_selectedCountry.dialCode}${widget.controller.text}';
    widget.onFullPhoneChanged?.call(fullPhone);
  }

  /// Полный номер телефона с кодом страны
  String get fullPhoneNumber {
    return '${_selectedCountry.dialCode}${widget.controller.text}';
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _CountryPickerSheet(
        countries: _countries,
        selectedCountry: _selectedCountry,
        onSelected: (country) {
          setState(() => _selectedCountry = country);
          _onPhoneChanged();
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onPhoneChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          // Кнопка выбора страны
          GestureDetector(
            onTap: _showCountryPicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.white.withOpacity(0.2)),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    _selectedCountry.flag,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _selectedCountry.dialCode,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white.withOpacity(0.6),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          // Поле ввода номера
          Expanded(
            child: TextField(
              controller: widget.controller,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: widget.hintText ?? 'Номер телефона',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet для выбора страны
class _CountryPickerSheet extends StatefulWidget {
  final List<Country> countries;
  final Country selectedCountry;
  final ValueChanged<Country> onSelected;

  const _CountryPickerSheet({
    required this.countries,
    required this.selectedCountry,
    required this.onSelected,
  });

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  final _searchController = TextEditingController();
  List<Country> _filteredCountries = [];

  @override
  void initState() {
    super.initState();
    _filteredCountries = widget.countries;
    _searchController.addListener(_filterCountries);
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCountries = widget.countries.where((c) {
        return c.name.toLowerCase().contains(query) ||
            c.dialCode.contains(query) ||
            c.code.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a2e),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          // Ручка
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Заголовок
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Выберите страну',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Поиск
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Поиск страны...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white.withOpacity(0.4),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Список стран
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCountries.length,
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                final isSelected = country.code == widget.selectedCountry.code;
                return ListTile(
                  leading: Text(
                    country.flag,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    country.name,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.8),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: Text(
                    country.dialCode,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor: Colors.white.withOpacity(0.1),
                  onTap: () => widget.onSelected(country),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
