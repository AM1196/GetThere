
<%@ page import ="java.sql.*" %>
<%@ page import ="javax.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
       
        
    <meta charset="UTF-8" />
    
    
    <script src="https://maps.googleapis.com/maps/api/js?v=3.exp"></script>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <script src="http://google-maps-utility-library-v3.googlecode.com/svn/trunk/routeboxer/src/RouteBoxer.js"></script>
    <title>GetThere</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
  <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
  <style>
  .jumbotron {
      background-color: #ccccff;
      color: #333333;
  }
  #contactform { 
  position: absolute; 
  z-index: 1; 
  width: 300px;
  margin: auto ;
  padding: 10px;
  background: black;
  height: auto;
  opacity: .85;  
  color: white;
  top:0px;
}
  </style>
     <div id="map"></div>
     <div id="contactform">
    <div class="jumbotron text-center ">
        
  
    <div class=" form-group" id="floating-panel">
    <h3>Mode of Travel: </h3>
    <select id="mode" name="mode">
      <option value="DRIVING">Driving</option>
      <option value="WALKING">Walking</option>
      
      <option value="TRANSIT">Transit</option>
      <option value="WHEELCHAIR">Wheelchair</option>
    </select>
    </div>
   
        <div class=" form-group">
            <br>
    <h3>Calculate your route</h3>
    <form id="calculate-route" name="calculate-route" >
      <label for="from">From:</label>
      <input type="text" id="from" name="from" required="required" placeholder="An address" size="30" />
      
      <br>

      <label for="to">To:</label> <br>
      <input type="text" id="to" name="to" required="required" placeholder="Another address" size="30" />
      
      <br>

      <input type="submit"  value="Submit" />
      <input type="reset" value="Reset" />
    </form>
        </div>
     <form>
          <h4>Show alternative routes</h3>
    <input type="checkbox" name="alternative routes"  id="altroutes"  />
     </form>
       
    </div>
   </div>
 
    <p id="error"></p>
           <div class="col-sm-4 " style="background-color:#9999ff;" >
          <h3>Markers </h3>
          
  <table class="table table-hover" >
    <thead>
      <tr>
        <th>Color</th>
        <th>Difficulty Level</th>
        
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><img src='http://maps.google.com/mapfiles/ms/icons/yellow-dot.png '></img>yellow</td>
        <td>Easy</td>
        
      </tr>
      <tr>
        <td><img src='http://maps.google.com/mapfiles/ms/icons/orange-dot.png '></img>orange</td>
        <td>Medium</td>
        
      </tr>
      <tr>
        <td><img src='http://maps.google.com/mapfiles/ms/icons/red-dot.png '></img>red</td>
        <td>Very Difficult</td>
        
      </tr>
    </tbody>
  </table>
          </div> 
       
    
   
    <sql:setDataSource var="dbcon" driver="com.mysql.jdbc.Driver"
                   url="jdbc:mysql://localhost/mark"
                   user="root" password="" />
        
         <sql:query dataSource="${dbcon}"  var="result">
            select * from mark;
        </sql:query>
            
                      
            
            
            
                
    <script>
        var directionsDisplay;
        var directionsService = new google.maps.DirectionsService();
        var mapObject;
        var routeBoxer = null;
        var boxpolys = null;
        var rdistance = 0.005; // km
        var markers = [];
        var altroutes ;
        var pos = [
            <c:forEach var="rows" items="${result.rows}">
                {lat: ${rows.lat},lng: ${rows.lon}},
                            
            </c:forEach>
        ];
        var diff = [
            <c:forEach var="rows" items="${result.rows}">
                "${rows.diff}",
                            
            </c:forEach>
        ];
        var image = [
            <c:forEach var="rows" items="${result.rows}">
                "${rows.img}",
                            
            </c:forEach>
        ];
        
        function initialize() {
  
    
        mapObject = new google.maps.Map(document.getElementById("map"), {
          zoom: 15,
          center: new google.maps.LatLng(39.3667,  22.9443),
          mapTypeId: google.maps.MapTypeId.ROADMAP
        });
        directionsDisplay = new google.maps.DirectionsRenderer();
        directionsDisplay.setMap(map);
        routeBoxer = new RouteBoxer();
        for (j in pos){
            if (diff[j] == '3'){
        markers[j] = new google.maps.Marker({
                            position:  pos[j],
                            map: mapObject,
                            icon:'http://maps.google.com/mapfiles/ms/icons/red-dot.png',
                            title:"point",
                            dragable: true

                            });
                        }
                        else if(diff[j] == '2'){
                            markers[j] = new google.maps.Marker({
                            position:  pos[j],
                            icon:'http://maps.google.com/mapfiles/ms/icons/orange-dot.png',
                            map: mapObject,
                            title:"point",
                            dragable: true

                            });
                            
                        }
                        else{
                            markers[j] = new google.maps.Marker({
                            position:  pos[j],
                            map: mapObject,
                            icon:'http://maps.google.com/mapfiles/ms/icons/yellow-dot.png',
                            title:"point",
                            dragable: true

                            });
                            
                        }
                           
                          markers[j].setVisible(false);
                        }
                         google.maps.event.addListener( markers  , 'click', function() {
                            var infowindow = new google.maps.InfoWindow;
                            infowindow.setContent('Hi');
                           infowindow.open(mapObject,markers);
                        });
                       
        
       
      }
       
      function calculateRoute(from, to) {
        initialize();
        var myOptions = {
          zoom: 10,
          center: new google.maps.LatLng(39.3667,  22.9443),
          mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        
        var selectedMode = document.getElementById('mode').value;
        if (selectedMode == "WHEELCHAIR" ) {
            calculateWheelRoute(from,  to);
        }
        else{

        directionsService = new google.maps.DirectionsService();
        var directionsRequest = {
          origin: from,
          destination: to,
          provideRouteAlternatives: true,
          travelMode: google.maps.DirectionsTravelMode[selectedMode],
          unitSystem: google.maps.UnitSystem.METRIC
        };
        directionsService.route(
          directionsRequest,
          function(response, status)
          {
              
            if (status == google.maps.DirectionsStatus.OK)
            {   
                altroutes = document.getElementById('altroutes').checked;
                if (altroutes ==false){
                            new google.maps.DirectionsRenderer({
                       map: mapObject,
                       directions: response,
                       polylineOptions:{
                       strokeColor: '#0066cc',
                       strokeOpacity: 0.9,
                       strokeWeight: 5
                           },
                         
                     });
                        
          
          
          
              var route = response.routes[0];
                var summaryPanel = document.getElementById("directions_panel");

                    
                }
                else{
                for (var n = 0, len = response.routes.length; n < len; n++) {
                                    
                       if (n == '0'){ 
                            new google.maps.DirectionsRenderer({
                       map: mapObject,
                       directions: response,
                       polylineOptions:{
                       strokeColor: '#0066cc',
                       strokeOpacity: 0.9,
                       strokeWeight: 5
                           },
                         routeIndex: n
                     });
                    }
                    else{
                        new google.maps.DirectionsRenderer({
                          map: mapObject,
                          directions: response,
                          polylineOptions:{
                          strokeColor: 'cce5ff',
                          strokeOpacity: 0.4,
                          strokeWeight: 4
                              },
                            routeIndex: n
                        });
          }
                        
          
          
          
              var route = response.routes[n];
                var summaryPanel = document.getElementById("directions_panel");

               
              
            }
    }
            
                
            }
              
            
            else
              $("#error").append("Unable to retrieve your route<br />");
          }
        );
      }
      }
      
      function calculateWheelRoute(from,  to){
          
        directionsService = new google.maps.DirectionsService();
        var directionsRequest = {
          origin: from,
          destination: to,
          provideRouteAlternatives: true,
          travelMode: google.maps.DirectionsTravelMode.WALKING,
          unitSystem: google.maps.UnitSystem.METRIC
        };
        directionsService.route(
          directionsRequest,
          function(response, status)
          {
              
            if (status == google.maps.DirectionsStatus.OK)
            { 
                 altroutes = document.getElementById('altroutes').checked;
                 if (altroutes ==false){
                            new google.maps.DirectionsRenderer({
                       map: mapObject,
                       directions: response,
                       polylineOptions:{
                       strokeColor: '#0066cc',
                       strokeOpacity: 0.9,
                       strokeWeight: 5
                           },
                         
                     });
                        
          
          
          
              var route = response.routes[0];
                var summaryPanel = document.getElementById("directions_panel");
                
                
                var path = response.routes[0].overview_path;
                var boxes = routeBoxer.box(path, rdistance);
                
              
                drawBoxes(boxes); 
                var x;
                
                  clearBoxes();
                  setMarkers(boxes);

                    
                }
                 else{
                for (var n = 0, len = response.routes.length; n < len; n++) {
                    
                    if (n == '0'){ 
                            new google.maps.DirectionsRenderer({
                       map: mapObject,
                       directions: response,
                       polylineOptions:{
                       strokeColor: '#0066cc',
                       strokeOpacity: 0.9,
                       strokeWeight: 5
                           },
                         routeIndex: n
                     });
                    }
                    else{
                        new google.maps.DirectionsRenderer({
                          map: mapObject,
                          directions: response,
                          polylineOptions:{
                          strokeColor: 'cce5ff',
                          strokeOpacity: 0.4,
                          strokeWeight: 4
                              },
                            routeIndex: n
                        });
          }
          
          
          
              var route = response.routes[n];
                var summaryPanel = document.getElementById("directions_panel");

               
                var path = response.routes[n].overview_path;
                var boxes = routeBoxer.box(path, rdistance);
                
              
                drawBoxes(boxes); 
                var x;
                
                  clearBoxes();
                  setMarkers(boxes);
            }
        }
                
            }
              
            
            else
              $("#error").append("Unable to retrieve your route<br />");
          }
        );
      }
          
          
      
      function drawBoxes(boxes) {
        boxpolys = new Array(boxes.length);
        for (var i = 0; i < boxes.length; i++) {
          boxpolys[i] = new google.maps.Rectangle({
            bounds: boxes[i],
            fillOpacity: 0,
            strokeOpacity: 1.0,
            strokeColor: '#000000',
            strokeWeight: 1,
            map: mapObject
          });
        }
      }
      
      function setMarkers(boxes){
          
                for (var i = 0; i < boxes.length; i++) {
                    var bounds = boxes[i];
                   for (j in pos) {
                      
                        if(bounds.contains(markers[j].getPosition())){
                            markers[j].setVisible(true);
                         }
                  
                    }
                }
          
          
      }

      // Clear boxes currently on the map
      function clearBoxes() {
        if (boxpolys != null) {
          for (var i = 0; i < boxpolys.length; i++) {
            boxpolys[i].setMap(null);
          }
        }
        boxpolys = null;
      }
      google.maps.event.addDomListener(window, 'load', calculateRoute);

      $(document).ready(function() {
        // If the browser supports the Geolocation API
        if (typeof navigator.geolocation == "undefined") {
          $("#error").text("Your browser doesn't support the Geolocation API");
          return;
        }

        $("#from-link, #to-link").click(function(event) {
          event.preventDefault();
          var addressId = this.id.substring(0, this.id.indexOf("-"));

          navigator.geolocation.getCurrentPosition(function(position) {
            var geocoder = new google.maps.Geocoder();
            geocoder.geocode({
              "location": new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
            },
            function(results, status) {
              if (status == google.maps.GeocoderStatus.OK)
                $("#" + addressId).val(results[0].formatted_address);
              else
                $("#error").append("Unable to retrieve your address<br />");
            });
          },
          function(positionError){
            $("#error").append("Error: " + positionError.message + "<br />");
          },
          {
            enableHighAccuracy: true,
            timeout: 10 * 1000 // 10 seconds
          });
        });

        $("#calculate-route").submit(function(event) {
          event.preventDefault();
          calculateRoute($("#from").val(), $("#to").val());
        });
      });
      
      
      function placeMarker(location) {
  var marker = new google.maps.Marker({
    position: location,
    map: mapObject
  });
  var infowindow = new google.maps.InfoWindow({
    //content: 'Latitude: ' + location.lat() + '<br>Longitude: ' + location.lng()
     content: '<IMG BORDER="0" ALIGN="Left" SRC="image[i].jpg">'
  });
  infowindow.open(mapObject,marker);
}

google.maps.event.addDomListener(window, 'load', initialize);
      
      
      
    </script>
    <style type="text/css">
      #map {
        width: 1300px;
        height: 600px;
        margin-top: 0px;
      }
    </style>
  </head>
    </head>
    <body>
        
        
    
    
    
    </body>
    
    </div>
</html>
