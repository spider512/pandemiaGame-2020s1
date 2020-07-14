import personas.*
import manzanas.*
import wollok.game.*
import agentedesalud.*

object simulacion {
	var property diaActual = 0
	const property manzanas = []
	
	// parametros del juego
	
	const property chanceDePresentarSintomas = 30
	const property chanceDeContagioSinCuarentena = 25
	const property chanceDeContagioConCuarentena = 2
	const property personasPorManzana = 10
	const property duracionInfeccion = 20

	/*
	 * este sirve para generar un azar
	 * p.ej. si quiero que algo pase con 30% de probabilidad pongo
	 * if (simulacion.tomarChance(30)) { ... } 
	 */ 	
	method tomarChance(porcentaje) = 0.randomUpTo(100) < porcentaje

	method agregarManzana(manzana) { manzanas.add(manzana) }
	
	method debeInfectarsePersona(persona, cantidadContagiadores) {
		const chanceDeContagio = if (persona.respetaLaCuarentena()) 
			self.chanceDeContagioConCuarentena() 
			else 
			self.chanceDeContagioSinCuarentena()
		return (1..cantidadContagiadores).any({n => self.tomarChance(chanceDeContagio) })	
	}

	method crearManzana() {
		const nuevaManzana = new Manzana()
		
		(1..self.personasPorManzana()).forEach({x=>nuevaManzana.agregarPersona(new Persona(manzana=nuevaManzana))})
		return nuevaManzana
	}
	
	method pasaUnDia() {
        manzanas.forEach( { m => m.pasarUnDia() } )
        diaActual += 1
		console.println("terminó el día")
    }
    
	method agregarPersonaInfectada() {
        const manzanaDestino = manzanas.anyOne()
        const personaInfectada = new Persona()

        personaInfectada.manzana(manzanaDestino)
        personaInfectada.infectarse()
        manzanaDestino.agregarPersona(personaInfectada)
    }
    
    method totalDeInfectos(){
        return manzanas.sum({unaManzana => unaManzana.personasInfectadas()})
    }
    
    method totalDePersonas(){
        return manzanas.sum({unaManzana => unaManzana.genteViviendo()})
    }
    
     method totalConSintomas(){
        return manzanas.sum({unaManzana => unaManzana.cantidadDePersonasConSintomas()})
    }

    method estadoGeneral() {
         console.println("Día "+diaActual+", total de personas: "+self.totalDePersonas()+", infectados: "+self.totalDeInfectos()+", con síntomas " +self.totalConSintomas())
     }
     
     method acciones(){
     	keyboard.e().onPressDo({self.estadoGeneral()})
     	keyboard.o().onPressDo({self.pasaUnDia()})
     	keyboard.y().onPressDo({self.agregarPersonaInfectada()})
     }
    
     
    
}
