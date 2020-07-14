import personas.*
import simulacion.*
import wollok.game.*
import agentedesalud.*

class Manzana {
	const property personas = []
	var property position
	
	method image() {
		if(personas.all({p=>p.estaInfectada()})){ return "rojo.png"	}
		if(self.personasInfectadas()>7 ){
			if(self.personasInfectadas()<self.genteViviendo()) {	return "naranjaOscuro.png"	}
		}
		if(self.personasInfectadas().between(4,7)){	return "naranja.png" }
		if(self.personasInfectadas().between(1,3)){	return "amarillo.png" }
		return "blanco.png"
	}
	
	method esManzanaVecina(manzana) {
		return manzana.position().distance(position) == 1
	}

	method pasarUnDia() {
		self.transladoDeUnHabitante()
		self.simulacionContagiosDiarios()
		personas.forEach({ p => p.curacion() })	
	}
	
	method personaSeMudaA(persona, manzanaDestino) {
		personas.remove(persona)
		manzanaDestino.agregarPersona(persona)
	}
	
	method cantidadContagiadores() {
		return  personas.count({ p => p.estaInfectada() and not p.estaAislada() })
	}
	
	method noInfectades() {
		return personas.filter({ pers => not pers.estaInfectada() })
	} 	
	
	method simulacionContagiosDiarios() { 
		const cantidadContagiadores = self.cantidadContagiadores()
		if (cantidadContagiadores > 0) {
			self.noInfectades().forEach({ persona => 
				if (simulacion.debeInfectarsePersona(persona, cantidadContagiadores)) {
					persona.infectarse()
				}
			})
		}
	}
	
	method transladoDeUnHabitante() {
		const quienesSePuedenMudar = personas.filter({ pers => not pers.estaAislada() })
		if (quienesSePuedenMudar.size() > 2) {
			const viajero = quienesSePuedenMudar.anyOne()
			const destino = simulacion.manzanas().filter({ manz => self.esManzanaVecina(manz) }).anyOne()
			self.personaSeMudaA(viajero, destino)			
		}
	}
	
	method personasInfectadas() { return personas.count({ p=> p.estaInfectada()}) }
	
	method personasInfectadasNoAisladas() {
		return personas.filter({ p => p.estaInfectada() }).filter({ p => p.estaAislada() }).size()
	}

	method agregarPersona(persona) { personas.add(persona) }
	
	method genteViviendo() { return self.personas().size() }
	
	method manzanaActual() { return self }
	
	method cantidadDePersonasConSintomas() { return personas.count({ p=> p.presentaSintomas() }) }
}
