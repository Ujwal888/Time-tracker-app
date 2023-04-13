import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker_app/app/home/jobs/empty_content.dart';
import 'package:time_tracker_app/app/home/jobs/job_list_tile.dart';
import 'package:time_tracker_app/app/home/jobs/list_items_builder.dart';
import 'package:time_tracker_app/app/home/models/jobs.dart';
import 'package:time_tracker_app/common_widget/platform_alert_dialog.dart';
import 'package:time_tracker_app/common_widget/platform_exception_dialog.dart';
import 'package:time_tracker_app/services/auth.dart';
import 'package:time_tracker_app/services/database.dart';
import 'package:flutter/services.dart';

class JobsPage extends StatelessWidget {
  JobsPage({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signout();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await const PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout ?',
      cancelActionText: 'Cancel',
      defaultActionText: 'LogOut',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  // Future<void> _createJob(
  //   BuildContext context,
  // ) async {
  //   try {
  //     final database = Provider.of<Database>(context, listen: false);
  //     await database.createJob(const Job(name: 'Blogging', ratePerHour: 10));
  //   } catch (e) {
  //     showDialog(
  //         builder: (content) {
  //           return AlertDialog(
  //               title: const Text('Operation Failed'),
  //               content: Text(e.toString()));
  //         },
  //         context: context

  //         //   title: 'Operation failed',
  //         //   exception: PlatformException(code: e.toString()),
  //         // ).show(context);
  //         );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
        actions: [
          IconButton(
              onPressed: () => EditJobPage.show(context),
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              )),
        ],
      ),
      body: _buildContents(
        context,
      ),
    );
  }

  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
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

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<Job>>(
        stream: database.jobsStream(),
        builder: (context, snapshot) {
          return ListItemBuilder<Job>(
              snapshot: snapshot,
              itemBuilder: (context, job) => Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      color: Colors.red,
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) => _delete(context, job),
                    child: JobListTile(
                        job: job,
                        onTap: () => EditJobPage.show(context, job: job)),
                  ));
          // if (snapshot.hasData) {
          //   final jobs = snapshot.data;
          //   if (jobs!.isNotEmpty) {
          //     final children = jobs
          //         .map((job) => JobListTile(
          //             job: job,
          //             onTap: () => EditJobPage.show(context, job: job)))
          //         .toList();
          //     return ListView(children: children);
          //   }
          //   return const EmptyContent();
          // }
          // if (snapshot.hasError) {
          //   return const Center(child: Text('Some Error Occurred'));
          // }
          // return const Center(
          //   child: CircularProgressIndicator(),
          // );
        });
  }
}
