
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
                                alert("rojo");
                                marker.setIcon('ima/da.png');
                              }else if((("<?php echo $alor; ?>") <21) && ("<?php echo $alor; ?>") >11){
                                alert("amarillo");
                                marker.setIcon('ima/sa.png');

                              }else if ((("<?php echo $alor; ?>") <30) && (("<?php echo $alor; ?>") >21)){
                                alert("verde");
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
                          }
                            