onClipEvent(load){
	gi=17;
	g=gi; //gravedad
	vidai=100;
	vida=vidai;  //vida
	xscalei=_xscale;
	yscalei=_yscale;
	xscale=xscalei;
	yscale=yscalei;
	
	pesoi=70;  //peso
	peso=pesoi;
	fuerzai=20;  //fuerza
	fuerza=fuerzai;
	fuerzasi=120;
	fuerzas=0;  //fuerza de salto
	defensai=0;  //defensa
	defensa=defensai;
	penai=10; //penetracion de armadura
	pena=penai;
	velb=30;  //velocidad basica
	veli=(velb)*((100-peso)/100)+fuerzai/50;  //velocidad
	vel=veli;
	velcaidai=(70*0.1)+10;  //velocidad de caida
	velcaida=0;
	fureeni=0;  //fuerza de retroceso
	fureen=fureeni;
	nbi=10;
	nb=nbi;
	nbdi=0;
	nbd=nbdi;
	ngi=3;
	ng=ngi;
	velbalai=20;
	velbala=velbalai;
	
	ta=10;  //temporizador de ataque
	tae=0;  //temporizador de ataque enemigo
	te=0; //temporizador de especial
	tem=50;
	the=0; //temporizador para habilitar ataque especial
	them=100;
	tdi=5;
	td=tdi; //temporizador para disparar
	tbpi=10;
	tbp=tbpi;  //temporizador de bajar plataforma
	
	//Bloqueos de movimiento
	bloqiz=false;
	bloqde=false;
	bloqar=false;
	bloqab=false;
	
	
	
	//Estados
	j=1;
	i=1;
	fra=1;
	hd=true;
	saltosi=1;
	saltos=saltosi;
	reubicar=false;
	recargar=false;
	disparar=false;
	muerto=false;
	restarsaltos=false;
	reen=false;
	gcola=false;
	gcolacambio=false;
	daño=false;
	atespecial=false;
	atacando=false;
	saltando=false;
	caminando=false;
	cayendo=false;
	agachado=false;
	aterrisando=false;
	agarrandose=false;
	activo=false;
	this.pers.at._visible=false;
	
	//Establecimiento de variables dependientes de jugador
	if(_name=="pers1"){
		nump=1;
		dir="derecha";
		_xscale=-xscalei;
		arriba=69;
		apuntararriba=87;
		izquierda=65;
		derecha=68;
		abajo=83;
		atacar=32;
		especial=81;
		enemigo="pers2";
	}
	else if(_name=="pers2"){
		nump=2;
		dir="izquierda";
		_xscale=xscalei;
		apuntararriba=104;
		arriba=105;
		izquierda=100;
		derecha=102;
		abajo=101;
		atacar=39;
		especial=103;
		enemigo="pers1";
	}
	
	pvida=vida/500;
	pdefensa=defensa/100;
	precision=8/10;
	pvelx=vel/30;
	pvely=(fuerzasi-peso)/100;
	evasion=1-(_height/600);
	ppena=pena/100;
	pfuerza=fuerza/100;
	rango=(1366)/1366;
	velat=1-(1.4/3);
}
onClipEvent(enterFrame){
	//Temporizadores
	if(tgca>0)tgca--;
	if(td>0)td--;
	if(td==0) hd=true;
	if(nbd>=10)recargar=true;
	if(tbp<tbpi) tbp++;
	
	//Cambio de capa
	if(_root[enemigo]._y<_y) this.swapDepths(1);
	
	if(inicializar){
		activo=false;
		if(_name=="pers1"){
			dir="derecha";
			_x=-300;
			_y=-300;
			_xscale=-xscalei;
		}
		else{
			dir="izquierda";
			_x=1666;
			_y=900;
			_xscale=xscalei;
		}
		g=gi;
		vida=vidai;
		xscale=xscalei;
		yscale=yscalei;
	
		peso=pesoi;
		fuerza=fuerzai;
		fuerzas=0;
		defensa=defensai;
		pena=penai;
		velb=15;
		vel=veli;
		velcaida=0;
		fureen=fureeni;
		nb=nbi;
		nbd=nbdi;
		velbala=velbalai;
		ng=ngi;
	
		ta=10;
		tae=0;
		te=0;
		tem=50;
		the=0;
		them=100;
		td=tdi;
		
		j=1;
		i=1;
		fra=1;
		hd=true;
		saltosi=1;
		saltos=saltosi;
		reubicar=false;
		recargar=false;
		disparar=false;
		muerto=false;
		restarsaltos=false;
		reen=false;
		daño=false;
		recargar=false;
		atespecial=false;
		atacando=false;
		saltando=false;
		caminando=false;
		cayendo=false;
		agachado=false;
		aterrisando=false;
		agarrandose=false;
		if(_name=="pers1"){
			_root.pers1._x=_root.pi1._x;
			_root.pers1._y=_root.pi1._y;
		}
		else{
			_root.pers2._x=_root.pi2._x;
			_root.pers2._y=_root.pi2._y;
		}
		inicializar=false;
	}
	
	if(activo==true){
		//Cambio de direccion del personaje
		if(dir=="derecha"&&_xscale>0)_xscale*=-1;
		else if(dir=="izquierda"&&_xscale<0)_xscale*=-1;
		
		//Gravedad del asunto
		if(_root.suelo.hitTest(_x,_y-35,true)){
			_y-=30;
		}
		
		//Bloqueo con ambiente y jugador
		if(_root.suelo.hitTest(_x-_width/2,_y-35,true)||_root.suelo.hitTest(_x-_width/4,_y-_height,true)||_root.suelo.hitTest(_x-_width/4,_y-_height,true)){
			bloqiz=true;
		}else bloqiz=false;
		if(_root.suelo.hitTest(_x+_width/2,_y-35,true)||_root.suelo.hitTest(_x+_width/4,_y-_height,true)||_root.suelo.hitTest(_x+_width/4,_y-_height,true)){
			bloqde=true;
		}else bloqde=false;
		
		if(!cayendo&&!saltando&&!agachado&&!aterrisando&&!atacando&&!agarrandose&&!caminando&&!recargar&&!Key.isDown(apuntararriba)&&!atespecial){
			gotoAndStop("normal");
			pers.gotoAndStop("normal");
		}
		else if(!recargar&&!disparar&&!atacando&&!Key.isDown(apuntararriba)&&!atespecial){
			//gotoAndStop("normal");
			pers.gotoAndStop("normal");
			//pers.gotoAndStop("recargar");
		}
		/*if(recargar&&agachado){
			pers.gotoAndStop("recargar");
			
		}*/
		
		//Reaccion a salto
		if(_root.suelo.hitTest(_x,_y,true)||_root.plat.hitTest(_x,_y,true)){
			if(!caminando&&!agachado)gotoAndStop("normal");
			cayendo=false;
			restarsaltos=true;
		}
		else if(!_root.suelo.hitTest(_x,_y,true)&&!_root.plat.hitTest(_x,_y,true)){
			_y+=g;
			restarsaltos=false;
			if(_root.suelo.hitTest(_x,_y,true))fuerzas=0;
			if(!saltando) cayendo=true;
		}
		_y-=fuerzas;
		if(fuerzas==g) cayendo=true;
		if(fuerzas>0) fuerzas-=5;
		else fuerzas=0;
		if(fuerzas<g) saltando=false;
		
		////////Accion de teclas\\\\\\\\\\\\
		//Moverse a la derecha
		if(Key.isDown(derecha)){
			if(recargar&&!recuperar) recuperar=true;
			dir="derecha";
			if(!agachado&&!bloqde){
				_x+=vel;
				if(!saltando&&!cayendo)gotoAndStop("caminando");
				caminando=true;
			}
		}
		//Moverse a la izquierda
		else if(Key.isDown(izquierda)){
			if(recargar&&!recuperar) recuperar=true;
			dir="izquierda";
			if(!agachado&&!bloqiz){
				_x-=vel;
				if(!saltando&&!cayendo)gotoAndStop("caminando");
				caminando=true;
			}
		}
		else caminando=false;
		//Moverse hacia arriba o saltar
		if(Key.isDown(arriba)&&!bloqar&&!saltando&&!cayendo){
			if(recargar&&!recuperar) recuperar=true;
			if(restarsaltos){
				fuerzas=fuerzasi-peso;
				saltando=true;
				restarsaltos=false;
			}
		}
		//Moverse hacia abajo o agacharse
		if(Key.isDown(abajo)&&!bloqab){
			if(recargar&&!recuperar) recuperar=true;
			if(!agachado)agachado=true;
			gotoAndStop("agachado");
			if(tbp<tbpi&&_root.plat.hitTest(_x,_y,true)){
				_y+=20;
			}
		}
		//Apuntar hacia arriba
		if(Key.isDown(apuntararriba)&&!recargar&&!atespecial){
			pers.gotoAndStop("atacando");
		}
		//Ataque normal
		if(Key.isDown(atacar)&&vida>0){
			if(!recargar){
				atacando=true;
				pers.gotoAndStop("atacando");
			}
			if(hd&&nb>0&&td<=0&&!recargar){
				//if(dir=="derecha")_root.attachMovie("bala","bala"+nb+nump,100+nb,{_x:_x+15, _y:_y-_height/2});
				//else _root.attachMovie("bala","bala"+nb+nump,100+nb,{_x:_x-15, _y:_y-_height/2});
				disparar=true;
			}
			//atacando=true;
		}
		//Ataque especial
		if(Key.isDown(especial)&&!atespecial&&ng>0&&the<=0){
			atespecial=true;
		}
		//Ataques
		
		//Colision con daño
		/*if(this.pers.at.hitTest(_root[enemigo])&&daño==true&&pers.at._visible==true){
				if(pers.at.retroceso>0&&!_root[enemigo].reen){
					_root[enemigo].fureeni=pers.at.retroceso;
					if(_root[enemigo]._x<_x){
						_root[enemigo].fureeni=_root[enemigo].fureeni*-1;
					}
					_root[enemigo].fureen=_root[enemigo].fureeni;
					_root[enemigo].reen=true;
			   	}
			   	_root[enemigo].vida-=(pers.at.fuerza*(((100-_root[enemigo].defensai)*((100-pers.at.pena)/100))/100));
		}*/
		//Accion al morir
		if(vida<=0){
			vida=0;
			muerto=true;
			atacando=false;
			fureeni=0;
			fureen=fureeni;
			reen=false;
			if(_name.charAt(_name.length-1)=="1"){
				_root.textog.ganador="El ganador es "+_root.jugador2;
			}
			else _root.textog.ganador="El ganador es "+_root.jugador1;
			
			_root.textog._visible=true;
			activo=false;
		}
		
		////////////Reaccion a estados\\\\\\\\\\\\\\\
		if(disparar){
			pers.gotoAndStop("disparando");
			if(_root["bala3"+i+nump].existe!=true){
				duplicateMovieClip(_root.bala3,["bala3"+i+nump],300+i+(nump*20));
				if(Key.isDown(apuntararriba)){
					_root["bala3"+i+nump]._y=_y-_height-70;
					if(dir=="derecha")_root["bala3"+i+nump]._x=_x-17;
					else _root["bala3"+i+nump]._x=_x+15;
					//_root["bala3"+i+nump]._x=_x;
					_root["bala3"+i+nump].vely=velbala;
					_root["bala3"+i+nump].velx=0;
					_root["bala3"+i+nump]._rotation=90;
				}
				else{
					if(!agachado)_root["bala3"+i+nump]._y=_y-_height/3*2-10;
					else _root["bala3"+i+nump]._y=_y-_height/2;
					if(dir=="derecha")_root["bala3"+i+nump]._x=_x+_width/2+40;
					else _root["bala3"+i+nump]._x=_x-_width/2-40;
					_root["bala3"+i+nump].velx=velbala;
					_root["bala3"+i+nump].vely=0;
				}				
				_root["bala3"+i+nump].activo=true;
				nb--;
				hd=false;
				disparar=false;
				td=tdi;
				nbd++;
			}
			else i++;
			if(i==nbi+1) i=1;
		}else if(!disparar&&!recargar&&atacando)pers.gotoAndStop("atacando");
		//Recargar
		if(recargar&&!atespecial){
			pers.gotoAndStop("recargar");
			if(fra<18)fra++;
		}
		else fra=1;
		//Recuperar
		if(recuperar){
			pers.pers.gotoAndPlay(fra);
			recuperar=false;
		}
		/*else if(disparar&&atacando){
			pers.gotoAndStop("disparando");
		}
		else if(atacando&&!recargar&&!disparar){
			pers.gotoAndStop("atacando");
		}
		else pers.gotoAndStop("normal");*/
		//Agachado
		if(agachado){
			
		}
		//Saltando
		if(saltando){
			gotoAndStop("saltando");
		}
		//Cayendo
		if(cayendo){
			if(!saltando&&!_root.suelo.hitTest(_x,_y,true)&&!_root.plat.hitTest(_x,_y,true)) gotoAndStop("cayendo");
			
			//if(_root.suelo.hitTest(_x,_y-35,true)) gotoAndStop("aterrisando");
		}
		//Fuerza de retroceso
		if(reen){
			if(fureen>0){
				fureen--;
				if(!bloqde)_x+=fureen;
				if(fureen<fureeni/2){
					fureen/3;
					fureeni=fureeni/2;
				}
				if(fureen<=0){
					fureeni=0;
					fureen=0;
					reen=false;
				}
			}
			else if(fureen<0){
				fureen++;
				if(!bloqiz)_x+=fureen;
				if(fureen>fureeni/2){
					fureen/3;
					fureeni=fureeni/2;
				}
				if(fureen>=0){
					fureeni=0;
					fureen=0;
					reen=false;
				}
			}
		}
		//Ataques
		
		//Ataque especial
		if(atespecial&&the<=0){
			//Establecer valores temporales de ataque especial
			pers.gotoAndStop("lanzando");
			if(_root["granada1"+j+nump].existe!=true){
				duplicateMovieClip(_root.granada1,["granada1"+j+nump],j+(nump*20));
				if(Key.isDown(apuntararriba)){
					_root["granada1"+j+nump]._y=_y-_height-70;
					if(dir=="derecha")_root["granada1"+j+nump]._x=_x+27;
					else _root["granada1"+j+nump]._x=_x+15;
					//_root["bala3"+i+nump]._x=_x;
					_root["granada1"+j+nump].vely=velbala/2;
					_root["granada1"+j+nump].velx=0;
					_root["granada1"+j+nump]._rotation=90;
				}
				else{
					if(!agachado)_root["granada1"+j+nump]._y=_y-_height/3*2;
					else _root["granada1"+j+nump]._y=_y-_height/2+10;
					if(dir=="derecha")_root["granada1"+j+nump]._x=_x+_width/2+40;
					else _root["granada1"+j+nump]._x=_x-_width/2-40;
					_root["granada1"+j+nump].velx=velbala;
					_root["granada1"+j+nump].vely=0;
				}
				_root["granada1"+j+nump].activo=true;
				the=them;
				ng--;
			}
			else j++;
			if(j==ngi+1) j=1;
		}
		else if(the>0)the--;
		if(the==them-5) atespecial=false;
		if(atacando){
			//this.pers.cabeza.gotoAndStop("atacando");
		}
		//else this.pers.cabeza.gotoAndStop("normal");
	}
	if(muerto==true){
		gotoAndStop("muerto");
		if(_root.suelo.hitTest(_x,_y-35,true)){
			_y-=30;
		}
		if(_root.suelo.hitTest(_x,_y,true)){
			cayendo=false;
		}
		else if(!_root.suelo.hitTest(_x,_y,true)){
			_y+=g;
			if(_root.suelo.hitTest(_x,_y,true))fuerzas=0;
			if(!saltando) cayendo=true;
		}
	}
}
onClipEvent (keyUp) {
	//Accion al levantar la tecla abajo
	if ((Key.getCode() == abajo)) {
		agachado=false;
		tbp=0;
	}
	//Accion al levantar la tecla atacando
	if ((Key.getCode() == atacar)) {
		atacando=false;
	}
	//Accion al levantar la tecla arriba
	if ((Key.getCode() == apuntararriba)) {
		pers.gotoAndStop("normal");
		//restarsaltos=true;
	}
}
