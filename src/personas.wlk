import simulacion.*
import manzanas.*


class Persona {
	var property estaAislada = false
	var property estaInfectada = false
	var property diaDeInfeccion 
	var property presentaSintomas = false
	var property respetaCuarentena = true
	var property viveEnManzana   // position
	
	method estaInfectada() {
		return estaInfectada
		
	}
	
	method infectarse() {
		 diaDeInfeccion = simulacion.diaActual()
		 estaInfectada = true
	}
	
	method contagiarseDe(persona) {
		if ( self.viveEnManzana() == persona.viveEnManzana() ) { self.infectarse() }
		else { }
	}
}

