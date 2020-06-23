import personas.*
import simulacion.*
import wollok.game.*

class Manzana {
	const property personas = []
	var property position
	
	method image() {
		// reeemplazarlo por los distintos colores de acuerdo a la cantidad de infectados
		// también vale reemplazar estos dibujos horribles por otros más lindos
		return "blanco.png"
	}
	
	// este les va a servir para el movimiento
	method esManzanaVecina(manzana) {
		return manzana.position().distance(position) == 1
	}

	method pasarUnDia() {
		self.transladoDeUnHabitante()
		self.simulacionContagiosDiarios()
		// despues agregar la curacion
	}
	
	method personaSeMudaA(persona, manzanaDestino) {
		manzanaDestino.personas().add(persona)
		persona.viveEnManzana(manzanaDestino)
	}
	
	method cantidadContagiadores() {
		return self.cantPersonasInfectadasNoAisladas()
	
	}
	
	method noInfectades() {
		return personas.filter({ pers => not pers.estaInfectada() })
	} 
	
	method PersonasInfectadas() {
		return personas.filter({ pers => pers.estaInfectada() })
	}	
	
	method cantPersonasInfectadas() {
		return self.PersonasInfectadas().size()
	}
	
	method cantPersonasInfectadasNoAisladas() {
		return self.PersonasInfectadas().filter( { pers => pers.estaAislada() } ).size()
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
}
