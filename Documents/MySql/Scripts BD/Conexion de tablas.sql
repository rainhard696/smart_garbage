alter table usuarios
add constraint fk_rol_usuario
foreign key (IdRol) references roles(IdRol);


alter table persona
add constraint fk_person_user
foreign key (IdUsuario) references usuarios(IdUsuario);

alter table recolector
add constraint fk_rec_person
foreign key (IdPersona) references persona(IdPersona);


alter table supervisor
add constraint fk_sup_person
foreign key (IdPersona) references persona(IdPersona);

alter table asignacion
add constraint fk_rec_asign
foreign key (IdRecolector) references recolector(IdRecolector);

alter table asignacion
add constraint fk_sup_asign
foreign key (IdSupervisor) references usuarios(IdUsuario);

alter table asignacion
add constraint fk_cont_asign
foreign key (IdContenedor) references contenedor(IdContenedor);

