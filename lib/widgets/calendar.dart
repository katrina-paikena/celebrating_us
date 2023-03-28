import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../model/celebration.dart';
import '../service/service_locator.dart';
import '../service/storage/storage_service.dart';

class CalendarTab extends StatefulWidget {
  @override
  _CalendarTabState createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  StorageService _storageService = getIt<StorageService>();
  DateTime _selectedDate = DateTime.now();
  Map<DateTime, List<Celebration>> _celebrationsByDate = {};
  late Stream<List<Celebration>> _celebrationsStream;


  @override
  void initState() {
    super.initState();
    _celebrationsStream = _storageService.getAllCelebrations();
  }

  void _updateCelebrationsByDate(List<Celebration> celebrations) {
    final Map<DateTime, List<Celebration>> newCelebrationsByDate = {};
    for (final celebration in celebrations) {
      if (celebration.type == CelebrationType.birthday) {
        final date = DateTime.utc(
          celebration.date.year,
          celebration.date.month,
          celebration.date.day,
        );
        if (newCelebrationsByDate.containsKey(date)) {
          newCelebrationsByDate[date]!.add(celebration);
        } else {
          newCelebrationsByDate[date] = [celebration];
        }
      }
    }
    setState(() {
      _celebrationsByDate = newCelebrationsByDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TableCalendar(
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Colors.orange[400],
              shape: BoxShape.circle,
            ),
            selectedTextStyle: TextStyle(color: Colors.white),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
          ),
          calendarFormat: CalendarFormat.month,
          focusedDay: DateTime.now(),
          firstDay: DateTime.utc(2023, 01, 01),
          lastDay: DateTime.utc(2030, 12, 31),
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDate, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDate = selectedDay;
            });
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              final dateWithoutTime = DateTime.utc(
                date.year,
                date.month,
                date.day,
              );
              if (_celebrationsByDate.containsKey(dateWithoutTime)) {
                return Positioned(
                  bottom: 1,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => _showAddCelebrationDialog(context, _selectedDate),
      ),
    );
  }

  void _reloadData() {
    _celebrationsStream = _storageService.getAllCelebrations();
    _celebrationsStream.listen((celebrations) {
      _updateCelebrationsByDate(celebrations);
    });
  }

  void _showAddCelebrationDialog(BuildContext context, DateTime selectedDate) {
    final _nameController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add Celebration'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                'Date: ${DateFormat('MMMM d, yyyy').format(selectedDate)}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final celebration = Celebration(
                  name: _nameController.text,
                  date: selectedDate,
                  type: CelebrationType.birthday,
                );
                await getIt.get<StorageService>().saveCelebration(celebration);
                Navigator.pop(context);
                _reloadData();
              }
            },
          ),
        ],
      ),
    );
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _celebrationsStream.listen((celebrations) {
      _updateCelebrationsByDate(celebrations);
    });
  }

}