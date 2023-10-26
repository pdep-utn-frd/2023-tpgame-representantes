import wollok.game.*
import juego.*


object jefe{
	var property vida = 2
	var property position = game.center()
	var property fuego = []
	
	method image(){
		if (vida > 30){
			return "diabloJefe1.png"
		}
		
		else {
			return "diabloJefe.png"
		}
	}
	
	method perseguir(){
		game.onTick(2300,"perseguirJefe",{self.moverse(eagle.positionX(),eagle.positionY())})
		game.schedule(1300,{=> self.borrar()})
	}
	
	method moverse(destinoX,destinoY){
		position = game.at(
			position.x() + (destinoX - position.x())/2.3,
			position.y() + (destinoY - position.y())/2.3	
		)
		self.disparar()
		
	} 
	
	
	method disparar(){
		const fuegow = new Bola(position = self.position(),orientacion = 'w')
		const fuegoa = new Bola(position = self.position(),orientacion = 'a')
		const fuegos = new Bola(position = self.position(),orientacion = 's')
		const fuegod = new Bola(position = self.position(),orientacion = 'd')
		game.addVisual(fuegow)
		game.addVisual(fuegoa)
		game.addVisual(fuegos)
		game.addVisual(fuegod)
		fuegow.moverse('w')
		fuegoa.moverse('a')
		fuegos.moverse('s')
		fuegod.moverse('d')
		game.onCollideDo(fuegow,{algo => algo.chocoConBola(fuegow)})
		game.onCollideDo(fuegoa,{algo => algo.chocoConBola(fuegoa)}) 
		game.onCollideDo(fuegos,{algo => algo.chocoConBola(fuegos)}) 
		game.onCollideDo(fuegod,{algo => algo.chocoConBola(fuegod)})  
		fuego.add(fuegow)
		fuego.add(fuegoa)
		fuego.add(fuegos)
		fuego.add(fuegod)
		
	
	}
	
	method chocoConBola(algunFuego){}
	
	method chocoConEagle(){
		eagle.ataqueDeZombie()
	}
	
	method morir(){
		resident.final()
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
	
	
	method borrar(){
		game.onTick(2300,"borrarFuego",{self.borrarFuego()})	
	}
	
	method borrarFuego(){
		fuego.forEach({x=>game.removeVisual(x)})
		fuego.clear()
	}
	
	method generarPrisioneros(){
		game.onTick(10000,"generarPrisionero",{self.generarPrisionero()})
	}
	
	method generarPrisionero(){
		const prisionero = new Prisionero(position = resident.posicionAlAzar(),vida=3)
		game.addVisual(prisionero)
		prisionero.perseguir()
		 }
	 method  reiniciar(){
	 	vida = 50
		position = game.center()
		fuego = []
	 }
}





class Bola{
	var property position
	var property orientacion
	
	method image() = "fuego.png"
	
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
			game.onTick(200,"moverseBalaw",{self.cambiarPosicionW()})
		}
		else if (ultimaPos == 'a'){
			game.onTick(200,"moverseBalaa",{self.cambiarPosicionA()})
			
		}
		else if (ultimaPos == 's'){
			game.onTick(200,"moverseBalas",{self.cambiarPosicionS()})
	
		}
		else{
			game.onTick(200,"moverseBalad",{self.cambiarPosicionD()})
	
		}
	}
	
	method chocoConEagle(){
		eagle.ataqueDeZombie()
	}
	
	method chocoConBala(bala){}
	method chocoConBola(fuego){}
	
	
}



class Prisionero inherits Zombie{
	override method image(){
		if (vida == 3){
			return "prisionero.png"
		}
		else if (vida == 2){
			return "prisionero2.png"
		}
		else{
			return "prisionero3.png"
		}
	}
	
	
}









object puerta{
	var property position = game.at(5,5)
	method image() = "puerta.png"
	
	method preJefeFinal(){
		game.removeTickEvent("agregarZombie")
		game.removeTickEvent("agregarMegaZombie")
		game.removeTickEvent("agregarAguila")
		
	}
	
	method chocoConEagle(){
		self.jefeFinal()
	}
	
	method jefeFinal(){
		game.addVisual(pantallaJefe)
		game.schedule(5000,{=> game.removeVisual(pantallaJefe)})
		game.schedule(5000,{=> game.addVisual(jefe)})
		game.schedule(5000,{=> jefe.perseguir()})
		game.removeVisual(puerta1)
		game.removeVisual(self)
		game.schedule(10000,{=> jefe.generarPrisioneros()})
	}
	
	
	method chocoConBala(bala){}
	
}
// hay dos puertas para que ocupe 2 casillas
object puerta1{
	var property position = game.at(6,5)
	
	method chocoConEagle(){
		puerta.jefeFinal()
	}
	
	method chocoConBala(bala){}
	
}



object pantallaJefe{
	var property position= game.origin()
	method image() = "fondoDiablo1.jpg"
	method chocoConEagle(){}
	method chocoConBala(bala){}
}


