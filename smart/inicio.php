

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">


<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<link href="css/style.css" rel="stylesheet">
<link rel="stylesheet" href="css/bootstrap.min.css">
<link href="https://fonts.googleapis.com/css2?family=Titillium+Web:wght@300;400;600&display=swap" rel="stylesheet"> 
<link href="https://unpkg.com/ionicons@4.5.10-0/dist/css/ionicons.min.css" rel="stylesheet">
<script src="https://polyfill.io/v3/polyfill.min.js?features=default"></script>
<title> Smart Garbage</title>
<script
      src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAsApMA8A-YUeiW5C97lbyRIsrUH7Ee2kc&callback=initMap&libraries=&v=weekly"
      defer
    ></script>

</head>
<script type="text/javascript">
function tiempo(){
        var obj=$.ajax({
            url:'mos.php',
            datatype:'text',
            async:false

        }).responseText;
        document.getElementById("mi").innerHTML=obj;
       
}
setInterval(tiempo,4000);

</script>

<body>
<nav class="navbar navbar-expand-lg ">
          <div class="container">
  <a class="navbar-brand" href="#"><img src="ima/logo.png"  class="logo-brand" alt="logo" /> Smart Garbage</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
<i class="icon ion-md-menu"></i>
      
  </button>

  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav ml-auto">
      <li class="nav-item active">
        <a class="nav-link" href="#">Inicio <span class="sr-only">(current)</span></a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#">Registro</a>
      </li>
    
      <li class="nav-item">
        <a class="nav-link " href="#">Reporte</a>
      </li>
        <li class="nav-item">
        <a class="nav-link " href="#">Contactos</a>
      </li>
    </ul>
   </div>
  </div>
</nav>

<section id="cuerpo" >
 
                    <h1 style="padding-left:200px ; color:snow ;padding-top:30px" >CONTENEDORES</h1>
                      <div class="container">
                          <div class="container-center" >
                          

                          
                             
                            <div id="map" style="width:1100px ; height:600px"> Loading...</div>
                           
                            <div id="mi">
      
                                  <?php
                                    include("mos.php");
                                                                               
                                                                       
                                  ?>
                              </div>

                       <script >
                         "use strict";
                        
           
                     
           
           
        
                         
                        let map;
                        let markers = [];
                        let marker;

                        function initMap() {
                            const huancayo = {
                                lat: -12.0485071,
                                lng: -75.2376587,
                            };
                            map = new google.maps.Map(document.getElementById("map"), {
                                zoom: 17,
                                center: huancayo,
                            
                            }); 

                            map.addListener("click", (event) => {
                                addMarker(event.latLng);
                            }); 

                            addMarker(huancayo);
                        } 

                        function addMarker(location) {
                      
                          
                            const marker = new google.maps.Marker({
                                position: location,
                                map: map,
                               
                            });
                            markers.push(marker);
                            marker.addListener("click", cli);
                 
                            if((("<?php echo $alor; ?>") <11) && (("<?php echo $alor; ?>") >0)){
                              
                              marker.setIcon('ima/da.png');
                            }else if((("<?php echo $alor; ?>") <21) && ("<?php echo $alor; ?>") >11){
                              
                              marker.setIcon('ima/sa.png');

                            }else if ((("<?php echo $alor; ?>") <30) && (("<?php echo $alor; ?>") >21)){
                              
                              marker.setIcon('ima/ver.png');
                            
                            }
                         
                       
                          
                        } 
                        
                       
                      
                            
                       
                            
                                function cli (){
                                    window.open('WebForm3.aspx')
                                }

                        

                        function setMapOnAll(map) {
                            for (let i = 0; i < markers.length; i++) {
                                markers[i].setMap(map);
                            }
                        } 

                        function clearMarkers() {
                            setMapOnAll(null);
                        } 

                        function showMarkers() {
                            setMapOnAll(map);
                        } 

                        function deleteMarkers() {
                            clearMarkers();
                            markers = [];

                            setInterval(addMarker,4000);
                        }</script>
                            
                              </div>
                             

                      </div>
                          
                          
                          
                          
                          
                          
                             

                  </section>
                
                  
                  
   
    
</body>
</html>