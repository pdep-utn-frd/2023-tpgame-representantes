import wollok.game.*

object resident{
	
	method iniciar(){
		game.addVisualCharacter(eagle)
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
	
	
	
	
}



object eagle{
	var property position = game.origin()
	var property vida = 3
	var property luz = 100
	var property ultimaPosicion = 'w'
	const property balas = []
	
	method image() = "black.png"

	method chocoConEagle(){}
	
	method disparar(){
		
		const bala = new Bala(position = self.positionSiguiente())
		game.addVisual(bala)
		bala.moverse(ultimaPosicion)
		balas.add(bala) //para despues eliminarlas todas
		
	}
	
	method moverArriba(){
		ultimaPosicion = 'w'
		position = position.up(1)
	}
	
	method moverIzquierda(){
		ultimaPosicion = 'a'
		position = position.left(1)
	}
	method moverAbajo(){
		ultimaPosicion = 's'
		position = position.down(1)
	}
	method moverDerecha(){
		ultimaPosicion = 'd'
		position = position.right(1)
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
	
	
}


class Zombie{
	var property position
	var property vida = 3
	
	
	method perseguir(){
		game.onTick(3000,"perseguir",{self.moverse(eagle.position())})
	}
	
	method moverse(destino){
		position = game.at(
			if (position.x() < destino){
				position.x() + 1
			}
			else {
				position.x() - 1
			}, //posicion x hay que probar esto
			if (position.y() < destino){
				position.y() + 1
			}
			else {
				position.y() - 1
			}
		)
	}
	
	
	
	method image() = ""

	
	method chocoConEagle(){
		eagle.ataqueDeZombie()
	}
	
	
	
	
	
	
}