import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Yaniv {
  static Future<List<int>?> showSimpleModalDialog(
    BuildContext context,
    List<String> players,
  ) {
    List<int> newScore = List<int>.generate(players.length, (index) => 0);

    return showDialog<List<int>>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 350, maxWidth: 350),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.justify,
                    text: const TextSpan(
                      text: 'Enter a new round',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.black,
                        wordSpacing: 1,
                      ),
                    ),
                  ),
                  ...players.asMap().entries.map(
                        (entry) => Expanded(
                          child: CupertinoTextField(
                            prefix: Text(players[entry.key]),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: false, // here it goes
                              signed: false,
                            ),
                            maxLength: 3,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              if (value.isEmpty) {
                                return;
                              }

                              newScore[entry.key] = int.parse(value);
                            },
                          ),
                        ),
                      ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CupertinoButton(
                        color: Colors.black,
                        onPressed: () => Navigator.pop(context, newScore),
                        child: const Text('test'),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
