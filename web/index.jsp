
<%@page contentType="text/html" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<!DOCTYPE html>
<html lang="en">
<head>
    <script src="http://maps.googleapis.com/maps/api/js?sensor=false"></script>
 

 
 
  <title>GetThere</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
  <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
  <style>
  .jumbotron {
      background-color: #3366ff;
      color: #fff;
  }
  #googlemaps { 
  height: 100%; 
  width: 100%; 
  position:absolute; 
  top: 0; 
  left: 0; 
  z-index: 0;
}
 
#contactform { 
  position: relative; 
  z-index: 1; 
  width: 600px;
  margin: auto ;
  padding: 10px;
  background: black;
  height: auto;
  opacity: .85; 
  color: white;
}
  </style>
  
</head>
<body>
<div id="googlemaps"></div>
<div id="contactform">
 

<div class="jumbotron text-center">
    <div class="container">
  <h1>GetThere</h1> 
  <p>Move around the city</p> 
  <div class="col-md-6 col-md-offset-3" form-group>
   <form  method ="POST" action= "login.do" >
  
  User:<br>
  <input type="text" class= "form-control"  size="30" name="username" placeholder = "Username" required="required">
  <br>
  Password:<br>
  <input type="password" class= "form-control"  size="30" name="password" placeholder = "Password" required="required"> 
<br>
 <input type="submit" class="btn btn-danger" value="Submit">

</form> 
     </div> 
     
      
  </div>
</div>
</div>

<script>
 

var position = [39.3667,  22.9443];
 
function showGoogleMaps() {
 
    var latLng = new google.maps.LatLng(position[0], position[1]);
 
    var mapOptions = {
        zoom: 15,
        streetViewControl: false,
        scaleControl: true,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        center: latLng
    };
 
    map = new google.maps.Map(document.getElementById('googlemaps'),
        mapOptions);
 
    
   
}
 
google.maps.event.addDomListener(window, 'load', showGoogleMaps);
</script>
</body>
</html>
