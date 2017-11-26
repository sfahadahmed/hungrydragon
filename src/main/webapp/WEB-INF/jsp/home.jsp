<%--
  Author: Fahad Ahmed
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Hungry Dragon - The future of food delivery</title>

    <!-- Bootstrap Core CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="https://blackrockdigital.github.io/startbootstrap-shop-homepage/css/shop-homepage.css" rel="stylesheet">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>

<body>

    <!-- Navigation -->
    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
        <div class="container">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#">Hungry Dragon Food Delivery Service</a>
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav">
                    <li>
                        <a href="#">About</a>
                    </li>
                    <li>
                        <a href="#">Services</a>
                    </li>
                    <li>
                        <a href="#">Contact</a>
                    </li>
                </ul>
            </div>
            <!-- /.navbar-collapse -->
        </div>
        <!-- /.container -->
    </nav>

       <div id="map"></div>
    <!-- Page Content -->
    <div class="container">

<style>
      /* Always set the map height explicitly to define the size of the div
       * element that contains the map. */
      #map {
        height: 250px;
        width: 250px;
      }
</style>
<!-- derived from https://www.w3schools.com/html/html5_geolocation.asp and https://developers.google.com/maps/documentation/javascript/examples/place-search  -->
 <script>
      var map;
      var infowindow;

function showPositionError(error) {
    switch(error.code) {
        case error.PERMISSION_DENIED:
            document.getElementById("map").innerHTML = "User denied the request for Geolocation."
            break;
        case error.POSITION_UNAVAILABLE:
            document.getElementById("map").innerHTML = "Location information is unavailable."
            break;
        case error.TIMEOUT:
            document.getElementById("map").innerHTML = "The request to get user location timed out."
            break;
        case error.UNKNOWN_ERROR:
            document.getElementById("map").innerHTML = "An unknown error occurred."
            break;
        default:
            document.getElementById("map").innerHTML = "It should be impossible to see this text."
            break;
    }
} 
      function initMap() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(MapUserLocation, showPositionError);
       // var pyrmont = {lat: -33.867, lng: 151.195};
       // doMap(pyrmont);
    } else {
        document.getElementById("map").innerHTML = "Geolocation is not supported by this browser.";
    }
     }
      function MapUserLocation(position) {
        var pyrmont = {lat: position.coords.latitude, lng: position.coords.longitude};
        doMap(pyrmont);
      }
      function doMap(pyrmont) {
        map = new google.maps.Map(document.getElementById('map'), {
//        map = new google.maps.Map($("#map"), {
          center: pyrmont,
          zoom: 15
        });

        infowindow = new google.maps.InfoWindow();
        var service = new google.maps.places.PlacesService(map);
        service.nearbySearch({
          location: pyrmont,
          radius: 500,
          type: ['restaurant']
        }, callback);
      }

      function callback(results, status) {
        if (status === google.maps.places.PlacesServiceStatus.OK) {
	  var placeList = [];
          for (var i = 0; i < results.length; i++) {
            createMarker(results[i]);
	    var place = results[i];
            var placeLoc = place.geometry.location;
//alert(JSON.stringify(place));
//alert(JSON.stringify(placeLoc));
//alert(JSON.stringify(placeLoc.lat));
//alert(JSON.stringify(placeLoc.lng));
	    var placeDatum = {
	      address: place.vicinity,
// why doesn't this work ?!
	      //latitude = placeLoc.lat;
	      //longitude = placeLoc.lng;
	      latitude: 0,
	      longitude: 0,
	      location: placeLoc,
	      restaurantName: place.name
	    };
// why doesn't this work ?!
	    //placeDatum.latitude = placeLoc["lat"];
	    //placeDatum.longitude = placeLoc["lng"];
	    // use 'string math' to put latitude/longitude information in right spot
	    var locationString = JSON.stringify(placeLoc);
	    locationString = locationString.substring(7, locationString.length - 8);
	    var splitString = locationString.split(',');
	    placeDatum.latitude = splitString[0];
	    locationString = splitString[1];
	    locationString = locationString.substr(6);
	    placeDatum.longitude = locationString;
	    /* even this doesn't work!
	    var propKeys = Object.keys(placeLoc);
alert(JSON.stringify(propKeys));
	    for (var i = 0; i < propKeys.length; i+=1)
	    {
	      if (i == 0) {
	      	placeDatum.latitude = placeLoc[propKeys[i]];
	      } else {
	      	placeDatum.longitude = placeLoc[propKeys[i]];
	      }
	    }
	    */
//alert(JSON.stringify(placeDatum));
	    placeList.push(placeDatum);
          }
	  pushMarker(placeList);
        }
      }

      function pushMarker(placeList) {
	var newPlaceList = {
	  datalist: JSON.stringify(placeList)
	};
        $.ajax({
	  type: "post",
	  url: "/register/postrestaurantlist",
	  dataType: "json",
	  //contentType: "application/json; charset=utf-8",
	  contentType: "application/x-www-form-urlencoded",
	  traditional: true,
	  success: function(datum) {
	  },
	  error: function(xhr, status, error) {
	    if (xhr.hasOwnProperty("readyState"))
	    {
	      if (xhr.readyState == 4)
	      {
		// TODO FIXME solve the parseerror
		return;
	      }
	    }
alert(JSON.stringify([xhr, status, error]));
	  },
	  //data: JSON.stringify(placeList)
	  data: newPlaceList
	});
      }

      function createMarker(place) {
        var placeLoc = place.geometry.location;
        var marker = new google.maps.Marker({
          map: map,
          position: place.geometry.location
        });

        google.maps.event.addListener(marker, 'click', function() {
          infowindow.setContent(place.name);
          infowindow.open(map, this);
        });
      }
 </script>

        <div class="row">

            <div class="col-md-3">
                <details open><summary><p class="lead">Select Restaurant</p></a></summary>
                <div id="restaraunts" class="list-group">
                    <a href="#" class="list-group-item">Dragon Palace</a>
                    <a href="#" class="list-group-item">Golden Dragon</a>
                    <a href="#" class="list-group-item">Dragon Express</a>
                </div>
                </details>
            </div>

            <div class="col-md-9">

                <div class="row carousel-holder">

                    <div class="col-md-12">
                        <div id="carousel-example-generic" class="carousel slide" data-ride="carousel">
                            <ol class="carousel-indicators">
                                <li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
                                <li data-target="#carousel-example-generic" data-slide-to="1"></li>
                                <li data-target="#carousel-example-generic" data-slide-to="2"></li>
                            </ol>
                            <div class="carousel-inner">
                                <div class="item active">
					<h1 class="text-primary text-center">Dragon Palace</h1>
                                    <img class="slide-image" src="https://maps.zomato.com/osm/14/3764/5564.png" alt="Dragon Palace">
                                </div>
                                <div class="item">
					<h1 class="text-primary text-center">Golden Dragon</h1>
                                    <img class="slide-image" src="https://maps.zomato.com/osm/14/3772/5562.png" alt="Golden Dragon">
                                </div>
                                <div class="item">
					<h1 class="text-primary text-center">Dragon Express</h1>
                                    <img class="slide-image" src="http://a.tile.osm.org/15/7543/11129.png" alt="Dragon Express">
                                </div>
                            </div>
                            <a class="left carousel-control" href="#carousel-example-generic" data-slide="prev">
                                <span class="glyphicon glyphicon-chevron-left"></span>
                            </a>
                            <a class="right carousel-control" href="#carousel-example-generic" data-slide="next">
                                <span class="glyphicon glyphicon-chevron-right"></span>
                            </a>
                        </div>
                    </div>

                </div>

                <div class="row">

                    <div class="col-sm-4 col-lg-4 col-md-4">
                        <div class="thumbnail">
                            <img src="https://b.zmtcdn.com/data/reviews_photos/f27/2cdc7e0c88fe2aa4f49f649737455f27.jpg?fit=around%7C200%3A200&crop=200%3A200%3B%2A%2C%2A" alt="beef and broccoli">
                            <div class="caption">
                                <h4><a href="#">Beef and Broccoli</a>
                                <h4>$24.99</h4>
                                </h4>
                                <p>This is a short description. Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
                            </div>
                            <div class="ratings">
                                <p class="pull-right">15 reviews</p>
                                <p>
                                    <span class="glyphicon glyphicon-star"></span>
                                    <span class="glyphicon glyphicon-star"></span>
                                    <span class="glyphicon glyphicon-star"></span>
                                    <span class="glyphicon glyphicon-star"></span>
                                    <span class="glyphicon glyphicon-star"></span>
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-4 col-lg-4 col-md-4">
                        <div class="thumbnail">
                            <img src="https://b.zmtcdn.com/data/reviews_photos/468/a0a814d7a4ada12764987ce450fd8468.jpg?fit=around%7C200%3A200&crop=200%3A200%3B%2A%2C%2A" alt="sweet and sour veal">
                            <div class="caption">
                                <h4><a href="#">Sweet and Sour Veal</a>
                                <h4>$64.99</h4>
                                </h4>
                                <p>This is a short description. Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
                            </div>
                            <div class="ratings">
                                <p class="pull-right">12 reviews</p>
                                <p>
                                    <span class="glyphicon glyphicon-star"></span>
                                    <span class="glyphicon glyphicon-star"></span>
                                    <span class="glyphicon glyphicon-star"></span>
                                    <span class="glyphicon glyphicon-star"></span>
                                    <span class="glyphicon glyphicon-star-empty"></span>
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-4 col-lg-4 col-md-4">
                        <div class="thumbnail">
                            <img src="https://b.zmtcdn.com/data/reviews_photos/2af/281654faa69cf513cfe45d5aea7b52af.jpg?fit=around%7C200%3A200&crop=200%3A200%3B%2A%2C%2A" alt="chicken fried rice">
                            <div class="caption">
                                <h4><a href="#">Chicken Fried Rice</a>
                                <h4>$74.99</h4>
                                </h4>
                                <p>This is a short description. Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
                            </div>
                            <div class="ratings">
                                <p class="pull-right">31 reviews</p>
                                <p>
                                    <span class="glyphicon glyphicon-star"></span>
                                    <span class="glyphicon glyphicon-star"></span>
                                    <span class="glyphicon glyphicon-star"></span>
                                    <span class="glyphicon glyphicon-star"></span>
                                    <span class="glyphicon glyphicon-star-empty"></span>
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-4 col-lg-4 col-md-4">
                        <div class="thumbnail">
                            <img src="https://b.zmtcdn.com/data/reviews_photos/1a4/536aaf11a602883e505e49676b9cb1a4.jpg?fit=around%7C200%3A200&crop=200%3A200%3B%2A%2C%2A" alt="Hot Honey Chicken">
                            <div class="caption">
                                <h4><a href="#">Hot Honey Chicken</a>
                                <h4>$84.99</h4>
                                </h4>
                                <p>This is a short description. Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
                            </div>
                            <div class="ratings">
                                <p class="pull-right">6 reviews</p>
                                <p>
                                    <span class="glyphicon glyphicon-star"></span>
                                    <span class="glyphicon glyphicon-star"></span>
                                    <span class="glyphicon glyphicon-star"></span>
                                    <span class="glyphicon glyphicon-star-empty"></span>
                                    <span class="glyphicon glyphicon-star-empty"></span>
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-4 col-lg-4 col-md-4">
                        <div class="thumbnail">
                            <img src="https://b.zmtcdn.com/data/reviews_photos/0c9/8bafd1b95c54c07993f523f07b6f20c9.jpg?fit=around%7C200%3A200&crop=200%3A200%3B%2A%2C%2A" alt="cantonese chow mein">
                            <div class="caption">
                                <h4><a href="#">Cantonese Chow Mein</a>
                                <h4>$94.99</h4>
                                </h4>
                                <p>This is a short description. Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
                            </div>
                            <div class="ratings">
                                <p class="pull-right">18 reviews</p>
                                <p>
                                    <span class="glyphicon glyphicon-star"></span>
                                    <span class="glyphicon glyphicon-star"></span>
                                    <span class="glyphicon glyphicon-star"></span>
                                    <span class="glyphicon glyphicon-star"></span>
                                    <span class="glyphicon glyphicon-star-empty"></span>
                                </p>
                            </div>
                        </div>
                    </div>

                </div>

            </div>

        </div>

    </div>
    <!-- /.container -->

    <div class="container">

        <hr>

        <!-- Footer -->
        <footer>
            <div class="row">
                <div class="col-lg-12">
                    <p>Copyright &copy; Team Dragon 2017</p>
                    <p>Map and food images Copyright &copy; 2008-2017 - Zomato &trade; Media Pvt Ltd. All rights reserved.</p>
                </div>
            </div>
        </footer>

    </div>
    <!-- /.container -->

    <!-- jQuery -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>

    <!-- Google Places JavaScript API -->
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDy00HmmAp62qnc_Xlr3O6S5yrlyyDoUCw&libraries=places&callback=initMap" async defer></script>
</body>

</html>
