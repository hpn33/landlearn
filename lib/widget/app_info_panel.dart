import 'package:flutter/material.dart';
import 'package:landlearn/util/util.dart';

///
/// dialog to show
/// title
/// version
/// developer info
/// change log
class AppInfoDialog extends StatelessWidget {
  const AppInfoDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Material(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Land Learn',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Version',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Developed by',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(versionString),
                          Text('@hamed.pishdad.n'),
                        ],
                      ),
                    ),
                  ],
                ),
                // const Divider(),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text('Change Log:', style: TextStyle(fontSize: 24)),
                //     SizedBox(height: 8),
                //     Text('- Added new features',
                //         style: TextStyle(fontSize: 16)),
                //     Text('- Fixed bugs'),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
