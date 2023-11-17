import wollok.game.*
import jefe.*

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
		game.onTick(7000,"agregarAguila",{self.agregarAguila()})
	}
	
	method agregarZombie(){
		const zombie = new Zombie(position = self.posicionAlAzar(),vida=3)
		game.addVisual(zombie)
		zombie.perseguir()
	}
	method agregarMegaZombie(){
		const zombie = new MegaZombie(position = self.posicionAlAzar(),vida=10)
		game.addVisual(zombie)
		zombie.perseguir()
	}
	method agregarAguila(){
		const zombie = new Aguila(position = self.posicionAlAzar(),vida=2)
		game.addVisual(zombie)
		zombie.perseguir()
	}
	
	method posicionAlAzar(){ 
		return game.at(
			1.randomUpTo(game.width()),
			1.randomUpTo(game.height())
		)
	}
		
	method vidas(){
		game.addVisual(corazon1)
		game.addVisual(corazon2)
		game.addVisual(corazon3)
		
	}
	method terminarJuego(){
		game.clear()
		game.addVisual(carteldeDerrota)
		keyboard.enter().onPressDo({self.reiniciar()})
	}
	method final(){
		game.clear()
		game.addVisual(cartelfinal)
		keyboard.enter().onPressDo({self.reiniciar()})
	}
	 
	method reiniciar(){
		game.clear()
		eagle.reiniciar()
		jefe.reiniciar()
		self.iniciar()
	}
	
	
}

object eagle{
	var property position = game.origin()
	var property vida = 3
	var property imagen="black.png"
	var property recarga = 0
    var property balacera =[]
    var property puntaje = 0
	method image(){
		return imagen
	}
	method cambiarimagen(picture){
		imagen=picture
	}

	method chocoConEagle(){}
	method chocoConBala(bala){}
	method chocoConBola(algunFuego){}
	
	method disparar(direccion){
		if(direccion=='d'){self.cambiarimagen("black.png")}else {self.cambiarimagen("black1.png")}
		const maximobalas=5
		if (recarga < maximobalas) {
		const bala = new Bala(position = self.position(),orientacion = direccion)
		game.addVisual(bala)
		bala.moverse(direccion)
		game.onCollideDo(bala,{algo => algo.chocoConBala(bala)}) 
		recarga = recarga + 1
		balacera.add(bala)
		}
	}
	
	method sumarPunto(){
		puntaje = puntaje + 1 
		if(puntaje == 3){
			game.addVisual(puerta)
			game.addVisual(puerta1)
			puerta.preJefeFinal()
		}
	}
	
	
	
	method moverArriba(){
		if (position.y()!=6)
		{
		position = position.up(1)}
	}
	
	method moverIzquierda(){
		
		if (position.x()!=0)
		{
		self.cambiarimagen("black1.png")
		position = position.left(1)}
	}
	method moverAbajo(){
		if (position.y()!=0)
		{
		position = position.down(1)}
	}
	method moverDerecha(){
		if (position.x()!=12)
		{
		self.cambiarimagen("black.png")
		position = position.right(1)}
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
		balacera.forEach({x=>game.removeVisual(x)})
		balacera.clear()
		}
	}
	
	
	method reiniciar(){
		position = game.origin()
		vida = 3
		recarga = 0
    	balacera =[]
    	puntaje = 0
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
	
				game.removeTickEvent("moverseBalaw")
			} 
		position = position.up(1)
	}
	method cambiarPosicionA(){
		if (position.x() < 0){
				
			game.removeTickEvent("moverseBalaa")
			} 
		position = position.left(1)
	}
	method cambiarPosicionS(){
		if (position.y() < 0){
			
				game.removeTickEvent("moverseBalas")
			} 
		position = position.down(1)
	}
	method cambiarPosicionD(){
		if (position.x() > 14){
				
				game.removeTickEvent("moverseBalad")
			} 
		position = position.right(1)
	}
	
	
	
	
	method moverse(ultimaPos){
		if (ultimaPos == 'w'){
			game.onTick(150,"moverseBalaw",{self.cambiarPosicionW()})
		}
		else if (ultimaPos == 'a'){
			game.onTick(150,"moverseBalaa",{self.cambiarPosicionA()})
			
		}
		else if (ultimaPos == 's'){
			game.onTick(150,"moverseBalas",{self.cambiarPosicionS()})
	
		}
		else{
			game.onTick(150,"moverseBalad",{self.cambiarPosicionD()})
	
		}
	}
	
	method chocoConEagle(){}
	method chocoConBala(bala){}
	method chocoConBola(algunFuego){}
	
	
	
}


class Zombie{
	var property position
	var property vida 
	
	method perseguir(){
		game.onTick(3000,"perseguir",{self.moverse(eagle.positionX(),eagle.positionY())})
	}
	
	method moverse(destinoX,destinoY){
		position = game.at(
			position.x() + (destinoX - position.x())/2.3,
			position.y() + (destinoY - position.y())/2.3	
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
		bala.position(game.at(0,8))
		}
		else if (bala.orientacion() == 'a'){
		bala.position(game.at(-1,0))
		}
		else if (bala.orientacion() == 's'){
		bala.position(game.at(0,-1))
		}
		else if (bala.orientacion() == 'd'){
		bala.position(game.at(14,0))
		}		
		if (vida == 0){
			self.morir()
		}
	}
	
	method chocoConBola(algunFuego){}
	
	method morir(){
		eagle.sumarPunto()
		game.removeVisual(self)
		game.removeTickEvent("perseguir")
	}
	
	
}

class MegaZombie inherits Zombie {
	
	override method image(){
		if (vida <= 10 && vida > 7){
			return "zombiechatgpt.png"
		}
		if (vida <= 7 && vida > 3){
			return "zombiechatgpt1.png"
		}
		else {
			return "zombiechatgpt2.png"
		}
	}
	
	override method morir(){
		game.removeVisual(self)
		const zombie = new Zombie(position = self.position(),vida=3)
		game.addVisual(zombie)
		zombie.perseguir()
	}
	
}
class Aguila inherits Zombie{
	override method image(){
		return "aguila.png"
	}
	
	override method perseguir(){
		game.onTick(1000,"perseguir",{self.moverse(eagle.positionX(),eagle.positionY())})
	}
	override method moverse(destinoX,destinoY){
		position = game.at(
			position.x() + (destinoX - position.x())/1.9,
			position.y() + (destinoY - position.y())/1.9
		)
	}
}

object carteldeDerrota {
	var property position=game.origin()
	method image()="gameOver1.png"
}



const corazon1 = new Corazon(position = game.at(12,6))
const corazon2 = new Corazon(position = game.at(12,5))
const corazon3 = new Corazon(position = game.at(12,4))


class Corazon {
	var property position 
	method image()="corazon.png"
	method chocoConEagle(){}
	method chocoConBala(bala){}
	method chocoConBola(algunFuego){}
	method perdiovida(){
		game.removeVisual(self)}
}


object cartelfinal{
	var property position = game.origin()
	
	method image()="youWin.jpg"
	method chocoConEagle(){}
	method chocoConBala(bala){}
	method chocoConBola(algunFuego){}
}












