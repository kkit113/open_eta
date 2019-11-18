import 'package:open_eta/helpers/ui_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Disclaimer {
  UiHelper uiHelper = UiHelper();

  showDisclaimer(BuildContext context) {
    return showDialog(
        context: context,
        builder: (ctx) {
          return Center(
            child: SizedBox(
              width: uiHelper.scrWidth(context) * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Copyright @2019 katzkei',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.yellow,
                        decoration: TextDecoration.none),
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    'Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.yellow,
                        decoration: TextDecoration.none),
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    'The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.yellow,
                        decoration: TextDecoration.none),
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.yellow,
                        decoration: TextDecoration.none),
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    'ALL Data in the Software are obtained from "data.gov.hk" and is for reference purposes only, the authors do not guarantee their accuracy or reliability and accept no liability (whether in tort or contract or otherwise) for any loss or damage arising from any inaccuracies or omissions.',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.yellow,
                        decoration: TextDecoration.none),
                    overflow: TextOverflow.clip,
                  ),
                  Container(
                    width: 30,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
