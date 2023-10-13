import wollok.game.*
import juego.*


object jefe{
	var property vida = 50
	var property position = game.center()
	
	method image(){
		if (vida > 30){
			return "diabloJefe1.png"
		}
		
		else {
			return "diabloJefe.png"
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
		game.removeVisual(puerta1)
		game.removeVisual(self)
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