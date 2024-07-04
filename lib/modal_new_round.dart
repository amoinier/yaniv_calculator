import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaniv_calculator/player.dart';
import 'package:yaniv_calculator/round.dart';

class Yaniv {
  static Future<RoundWithoutBonus?> showSimpleModalDialog(
    BuildContext context,
    List<String> players,
  ) {
    List<int> newScore = List<int>.generate(players.length, (index) => 0);

    return showDialog<RoundWithoutBonus>(
      context: context,
      builder: (BuildContext context) {
        String? asafPlayerId;
        return StatefulBuilder(
          builder: (stfContext, stfSetState) {
            return Dialog(
              child: Container(
                constraints:
                    const BoxConstraints(maxHeight: 350, maxWidth: 400),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          RichText(
                            textAlign: TextAlign.justify,
                            text: const TextSpan(
                              text: 'Asaf?',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.black,
                                wordSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ...players.asMap().entries.map(
                            (entry) => Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      label: Text(
                                        Player.findPlayer(entry.value)?.name ??
                                            '',
                                      ),
                                    ),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
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
                                Checkbox(
                                  checkColor:
                                      const Color.fromARGB(255, 251, 244, 241),
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.disabled)) {
                                      return Colors.orange.withOpacity(.32);
                                    }
                                    return Colors.orange;
                                  }),
                                  value: asafPlayerId == entry.value,
                                  onChanged: (bool? value) {
                                    if (value != null) {
                                      stfSetState(() {
                                        if (asafPlayerId == entry.value) {
                                          asafPlayerId = null;
                                        } else {
                                          asafPlayerId = entry.value;
                                        }
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CupertinoButton(
                            color: Colors.black,
                            onPressed: () => Navigator.pop(
                              context,
                              RoundWithoutBonus(newScore, asafPlayerId),
                            ),
                            child: const Text('Submit'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
