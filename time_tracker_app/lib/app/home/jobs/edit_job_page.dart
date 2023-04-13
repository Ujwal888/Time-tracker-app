import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/home/models/jobs.dart';
import 'package:time_tracker_app/services/database.dart';

class EditJobPage extends StatefulWidget {
  EditJobPage({super.key, required this.database, required this.job});
  final Job? job;
  final Database database;
  static Future<void> show(BuildContext context, {Job? job}) async {
    final database = Provider.of<Database>(context, listen: false);

    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditJobPage(
          database: database,
          job: job,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<EditJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  int? _ratePerHour;
  @override
  void initState() {
    if (widget.job != null) {
      _name = widget.job?.name;
      _ratePerHour = widget.job?.ratePerHour;
    }
    super.initState();
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allName = jobs.map((job) => job.name).toList();
        if (widget.job != null) {
          allName.remove(widget.job?.name);
        }
        if (allName.contains(_name)) {
          showDialog(
              builder: (content) {
                return const AlertDialog(
                  title: Text('Name already exists'),
                  content: Text('Please choose different name'),
                );
              },
              context: context);
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(id: id, name: _name!, ratePerHour: _ratePerHour!);
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } catch (e) {
        showDialog(
            builder: (content) {
              return AlertDialog(
                  title: const Text('Operation Failed'),
                  content: Text(e.toString()));
            },
            context: context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
              onPressed: _submit,
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ))
        ],
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    GestureDetector(onTap: () {
      FocusScope.of(context).unfocus();
    });
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: 'Job Name'),
        initialValue: _name,
        onSaved: (value) => _name = value,
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Rate per hour'),
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        keyboardType: const TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
          // GestureDetector(onTap: (){
          //   FocusManager.instance.primaryFocus?.unfocus();
          // },)
        ),
        onSaved: (value) => _ratePerHour = int.tryParse(value!) ?? 0,
      ),
    ];
  }
}
