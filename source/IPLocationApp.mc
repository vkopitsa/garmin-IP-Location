/*   Copyright 2024 Volodymyr Kopytsia
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */

import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class IPLocationApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {

        if(!System.getDeviceSettings().phoneConnected) {
            return [new ConnectToGcmView() ];
        } else {
            var view = new IPLocationView();
            var delegat = new IPLocationDelegate();
            delegat.setView(view);
            return [view, delegat];
        }
    }

}

function getApp() as IPLocationApp {
    return Application.getApp() as IPLocationApp;
}