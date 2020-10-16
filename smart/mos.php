<?php

$inc = include("cone.php");
if($inc){
    $consulta = "SELECT distancia from datos ORDER BY id DESC LIMIT 1";
    $resultado = mysqli_query($conex,$consulta);
    if($resultado){
        while($row = $resultado->fetch_array()){
           
            $distancia = $row['distancia'];
            
            ?>
            <div>
            <h2 id="ga"><?php
           
            $alor=$distancia/1; 
            if(($alor<=10)&&($alor>0)){
               echo  "<font color='red'>" .$alor."</font>";
            }else if(($alor<=20)&&($alor>11)){
                echo  "<font color='yellow'>" .$alor."</font>";

            }else if(($alor<=30)&&($alor>21)){
                echo  "<font color='green'>" .$alor."</font>";
            }
           
                ?></h2>
                
                
                           
            </div>
    <?php
        }
    }
}


?>