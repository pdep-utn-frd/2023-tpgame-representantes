import wollok.game.*

object resident{
	
	method iniciar(){
		game.addVisual(eagle)
		game.onCollideDo(eagle,{algo => algo.chocoConEagle()})

		
		keyboard.w().onPressDo({
			eagle.moverArriba()
		})
		keyboard.a().onPressDo({
			eagle.moverIzquierda()
		})
		keyboard.s().onPressDo({
			eagle.moverAbajo()
		})
		keyboard.d().onPressDo({
			eagle.moverDerecha()
		})
		
		keyboard.up().onPressDo({
			eagle.disparar('w')
		})
		keyboard.down().onPressDo({
			eagle.disparar('s')
		})
		keyboard.right().onPressDo({
			eagle.disparar('d')
		})
	
		keyboard.left().onPressDo({
			eagle.disparar('a')
		})
		
		keyboard.r().onPressDo({
			eagle.recargar()
		})
		
		self.generarEnemigos()
		
		self.vidas()
		
		
		
	}
	
	method generarEnemigos(){
		game.onTick(10000,"agregarZombie",{self.agregarZombie()})
		game.onTick(20000,"agregarMegaZombie",{self.agregarMegaZombie()})
	}
	
	method agregarZombie(){
		const zombie = new Zombie(position = self.posicionAlAzar())
		game.addVisual(zombie)
		zombie.perseguir()
	}
	method agregarMegaZombie(){
		const zombie = new MegaZombie(position = self.posicionAlAzar())
		game.addVisual(zombie)
		zombie.perseguir()
	}
	
	method posicionAlAzar(){ //HAY QUE DESARROLLAR ESTO
		return game.at(
			1.randomUpTo(game.width()),
			1.randomUpTo(game.height())
		)
	}
	
	//method eliminarBalas(){
		//(eagle.balas()).forEach{ b => game.removeVisual(b)}
		//game.removeTickEvent("moverseBala")
	//}
	//tablero
	
	method vidas(){
		game.addVisual(corazon1)
		game.addVisual(corazon2)
		game.addVisual(corazon3)
		
	}
	method terminarJuego(){
		game.removeTickEvent("agregarZombie")
		game.clear()
		game.addVisual(carteldeDerrota)
		keyboard.enter().onPressDo({self.reiniciar()})
	}
	 
	method reiniciar(){
		game.clear()
		eagle.reiniciar()
		self.iniciar()
	}
	
	
}



object eagle{
	var property position = game.origin()
	var property vida = 3
	var property ultimaPosicion = 'w'
	var property recarga = 0
	var property apuntado = 'd'

	
	method image(){
		if (ultimaPosicion == 'a' ||apuntado == 'a'){
			return "black1.png"
		}
		else {
			return "black.png"
		}
	} 
	

	method chocoConEagle(){}
	method chocoConBala(bala){}
	
	method disparar(direccion){
		if (recarga < 5) {
		apuntado = direccion
		const bala = new Bala(position = self.position(),orientacion = direccion)
		game.addVisual(bala)
		bala.moverse(direccion)
		game.onCollideDo(bala,{algo => algo.chocoConBala(bala)}) 
		recarga = recarga + 1
		//game.schedule(600,{game.removeVisual(bala)})
		//game.schedule(600,{game.removeTickEvent("moverseBala")})
		  //SE LAGUEA 
		}
	}
	
	
	method moverArriba(){
		if (position.y()==6)
		{ultimaPosicion = 'w'}
		else
		{ultimaPosicion = 'w'
		position = position.up(1)}
	}
	
	method moverIzquierda(){
		if (position.x()==0)
		{ultimaPosicion = 'a'}
		else
		{ultimaPosicion = 'a'
		position = position.left(1)}
	}
	method moverAbajo(){
		if (position.y()==0)
		{ultimaPosicion = 's'}
		else
		{ultimaPosicion = 's'
		position = position.down(1)}
	}
	method moverDerecha(){
		if (position.x()==12)
		{ultimaPosicion = 'd'}
		else
		{ultimaPosicion = 'd'
		position = position.right(1)}
	}
	
	
	method positionSiguiente(){
		if (ultimaPosicion == 'w'){
			return position.up(1)
		}
		if (ultimaPosicion == 'a'){
			return position.left(1)
		}
		if (ultimaPosicion == 's'){
			return position.down(1)
		}
		else{
			return position.right(1)
		}
	}
	
	method ataqueDeZombie(){
		vida = vida - 1
		if (self.vida() == 2)
		{corazon3.perdiovida()}
		if (self.vida() == 1)
		{corazon2.perdiovida()}
		if (self.vida() == 0){
		resident.terminarJuego()
		}
	}
	
	method positionX(){
		return position.x()
	}
	method positionY(){
		return position.y()
	}
	
	
	method recargar(){
		if (recarga == 5){
		recarga = 0

		}
	}
	
	
	method reiniciar(){
		position = game.origin()
		vida = 3
		ultimaPosicion = 'w'
	}
}


class Bala{
	var property position
	var property orientacion
	
	method image(){
		if (orientacion == 'w' or orientacion == 's'){
			return "bala.png"
		}
		else {
			return "bala1.png"
		}
	}
	
	method cambiarPosicionW(){
		if (position.y() > 8){
				game.removeVisual(self)
				game.removeTickEvent("moverseBalaw")
			} 
		position = position.up(1)
	}
	method cambiarPosicionA(){
		if (position.x() < 0){
				game.removeVisual(self)
				game.removeTickEvent("moverseBalaa")
			} 
		position = position.left(1)
	}
	method cambiarPosicionS(){
		if (position.y() < 0){
				game.removeVisual(self)
				game.removeTickEvent("moverseBalas")
			} 
		position = position.down(1)
	}
	method cambiarPosicionD(){
		if (position.x() > 14){
				game.removeVisual(self)
				game.removeTickEvent("moverseBalad")
			} 
		position = position.right(1)
	}
	
	
	
	
	method moverse(ultimaPos){
		if (ultimaPos == 'w'){
			game.onTick(100,"moverseBalaw",{self.cambiarPosicionW()})
		}
		else if (ultimaPos == 'a'){
			game.onTick(100,"moverseBalaa",{self.cambiarPosicionA()})
			
		}
		else if (ultimaPos == 's'){
			game.onTick(100,"moverseBalas",{self.cambiarPosicionS()})
	
		}
		else{
			game.onTick(100,"moverseBalad",{self.cambiarPosicionD()})
	
		}
	}
	
	method chocoConEagle(){}
	method chocoConBala(bala){}
	
	
	
}


class Zombie{
	var property position
	var property vida = 3
	
	method perseguir(){
		game.onTick(3000,"perseguir",{self.moverse(eagle.positionX(),eagle.positionY())})
	}
	
	method moverse(destinoX,destinoY){
		position = game.at(
			position.x() + (destinoX - position.x())/3,
			position.y() + (destinoY - position.y())/3	
		)
	}
	
	
	
	method image(){
		if (vida == 3){
			return "zombie.png"
		}
		if (vida == 2){
			return "zombieGolpeado.png"
		}
		else {
			return "zombiePorMorir.png"
		}
	}

	
	method chocoConEagle(){
		eagle.ataqueDeZombie()
	}
	
	method chocoConBala(bala){
		vida = vida - 1
		if (bala.orientacion() == 'w'){
		game.removeTickEvent("moverseBalaw")
		}
		else if (bala.orientacion() == 'a'){
		game.removeTickEvent("moverseBalaa")
		}
		else if (bala.orientacion() == 's'){
		game.removeTickEvent("moverseBalas")
		}
		else if (bala.orientacion() == 'd'){
		game.removeTickEvent("moverseBalad")
		}
		game.removeVisual(bala)
		
		if (vida == 0){
			self.morir()
		}
	}
	
	
	
	method morir(){
		game.removeVisual(self)
		game.removeTickEvent("perseguir")
	}
	
	
}

class MegaZombie inherits Zombie {
	
	// preguntar como hacer para cambiar la vida
	
	override method image(){
		return "NuevoMegazombie.png"
	}
	
	override method morir(){
		game.removeVisual(self)
		const zombie = new Zombie(position = self.position())
		game.addVisual(zombie)
		zombie.perseguir()
	}
	
}


object carteldeDerrota {
	var property position=game.origin()
	method image()="gameOver.jpg"
}



object corazon1 {
	var property position=game.at(12,6)
	method image()="corazon.png"
	method chocoConEagle(){}
	method chocoConBala(bala){}
}	

object corazon2 {
	var property position=game.at(12,5)
	method image()="corazon.png"
	method chocoConEagle(){}
	method chocoConBala(bala){}
	method perdiovida(){
		game.removeVisual(self)}
		
}

object corazon3 {
	var property position=game.at(12,4)
	method image()="corazon.png"
	method chocoConEagle(){}
	method chocoConBala(bala){}
	method perdiovida(){
		game.removeVisual(self)
	}
}
