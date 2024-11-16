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

import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

using Toybox.Communications;

using Toybox.Graphics;

class IPLocationView extends WatchUi.View {

    hidden var mYOffset = 0;
    hidden var mYResetOffset = 0;
    hidden const elements as Array<String> = [
        "title",

        "ipLabel",
        "ip",

        "countryLabel",
        "country",

        "cityLabel",
        "city",

        "regionLabel",
        "region",

        "continentLabel",
        "continent",

        "currencyLabel",
        "currency",

        "latitudeLabel",
        "latitude",

        "longitudeLabel",
        "longitude",
    ] as Array<String>;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.Summary(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        makeRequest("https://freeipapi.com/api/json/", {}, method(:onReceiveIpInfo));
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        for (var i = 0; i < elements.size(); i++) {
            var value = findDrawableById(elements[i as Number] as String) as WatchUi.Drawable;
            value.setLocation( value.locX, value.locY + (mYOffset * (dc.getHeight() * 0.1)) );
        }

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        mYOffset = 0;
        mYResetOffset = 0;

        Communications.cancelAllRequests();
    }

    // ----- 
    function scrollUp(){
        mYOffset = -1;
        mYResetOffset -= 1;
        requestUpdate();
    }

    function scrollDown(){
        mYOffset = 1;
        mYResetOffset += 1;
        requestUpdate();
    }

    function scrollReset(){
        mYOffset = -mYResetOffset;
        mYResetOffset = 0;
        requestUpdate();
    }

    function onReceiveIpInfo(responseCode as Number, data as Dictionary) as Void {
       if (responseCode == 200) {
            (findDrawableById("ip") as WatchUi.Text).setText(data["ipAddress"]);
            (findDrawableById("country") as WatchUi.Text).setText(data["countryName"]);
            (findDrawableById("city") as WatchUi.Text).setText(data["cityName"]);
            (findDrawableById("region") as WatchUi.Text).setText(data["regionName"]);
            (findDrawableById("continent") as WatchUi.Text).setText(data["continent"]);
            (findDrawableById("currency") as WatchUi.Text).setText((data["currency"] as Dictionary)["code"]);

            (findDrawableById("latitude") as WatchUi.Text).setText(data["latitude"].format("%.6f"));
            (findDrawableById("longitude") as WatchUi.Text).setText(data["longitude"].format("%.6f"));
            requestUpdate();
       } else {
           // TODO: handle error
       }
   }

   function makeRequest(url as String, params as Dictionary, responseCallback) {
       var options = {                                             // set the options
           :method => Communications.HTTP_REQUEST_METHOD_GET,      // set HTTP method
           :headers => {                                           // set headers
                   "Content-Type" => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON},
                                                                   // set response type
           :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
       };

       // make request call
       Communications.makeWebRequest(url, params, options, responseCallback);
    }

}
