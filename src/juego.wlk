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
		
		
		keyboard.space().onPressDo({
			eagle.disparar()
		})
		
		self.generarEnemigos()
		
		
		
	}
	
	method generarEnemigos(){
		game.onTick(10000,"agregarZombie",{self.agregarZombie()})
	}
	
	method agregarZombie(){
		const zombie = new Zombie(position = self.posicionAlAzar())
		game.addVisual(zombie)
		zombie.perseguir()
	}
	
	method posicionAlAzar(){ //HAY QUE DESARROLLAR ESTO
		return game.at(
			1.randomUpTo(game.width()),
			1.randomUpTo(game.height())
		)
	}
	
	method eliminarTodo(){
		(eagle.balas()).forEach{ b => game.removeVisual(b)}
	}
	//tablero
	
	method terminarJuego(){
		game.removeTickEvent("agregarZombie")
		game.clear()
		game.addVisual(cartelDeDerrota)
	}
	 
	
	
	
}



object eagle{
	var property position = game.origin()
	var property vida = 3
	var property luz = 100
	var property ultimaPosicion = 'w'
	const property balas = []
	
	method image(){
		if (ultimaPosicion == 'a'){
			return "black1.png"
		}
		else {
			return "black.png"
		}
	} 
	

	method chocoConEagle(){}
	method chocoConBala(bala){}
	
	method disparar(){
		
		const bala = new Bala(position = self.positionSiguiente())
		game.addVisual(bala)
		bala.moverse(ultimaPosicion)
		balas.add(bala)//para despues eliminarlas todas
		game.onCollideDo(bala,{algo => algo.chocoConBala(bala)}) 
		
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
	
	
}


class Bala{
	var property position
	method image() = "bala.png"
	
	method moverse(ultimaPos){
		if (ultimaPos == 'w'){
			game.onTick(500,"moverseBala",{position = position.up(1)})
		}
		else if (ultimaPos == 'a'){
			game.onTick(500,"moverseBala",{position = position.left(1)})
		}
		else if (ultimaPos == 's'){
			game.onTick(500,"moverseBala",{position = position.down(1)})
		}
		else{
			game.onTick(500,"moverseBala",{position = position.right(1)})
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
	
	method moverse(destinoX,destinoY){// error, se mueven en diagonal
		position = game.at(
			if (position.x() > destinoX){
				position.x() - 1
			}
			else if (position.x() < destinoX){
				position.x() + 1
			}
			else {
				position.x() 
			}, 
			if (position.y() > destinoY){
				position.y() - 1
			}
			else if (position.y() < destinoY){
				position.y() + 1
			}
			else {
				position.y() 
			}
		)
	}
	
	
	
	method image() = "zombie.png"

	
	method chocoConEagle(){
		eagle.ataqueDeZombie()
	}
	
	method chocoConBala(bala){
		vida = vida - 1
		game.removeVisual(bala)
		if (vida == 0){
			self.morir()
		}
	}
	
	
	
	method morir(){
		game.removeVisual(self)
	}
	
	
}




object cartelDeDerrota{
	
}


