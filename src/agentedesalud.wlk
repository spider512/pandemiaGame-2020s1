import wollok.game.*
import manzanas.*
import personas.*
import simulacion.*

object agenteDeSalud {
	var property image = "agente.png"
    var property position = game.origin()
    var property memoriaManzana
   	
	method moverAgente() {
	        keyboard.up().onPressDo({self. moverseHacia(self.position().up(1))})
	        keyboard.down().onPressDo({self. moverseHacia(self.position().down(1))})
	        keyboard.right().onPressDo({self. moverseHacia(self.position().right(1))})
	        keyboard.left().onPressDo({self. moverseHacia(self.position().left(1))})
	       
	       	keyboard.x().onPressDo({self.aislar()})
   			keyboard.z().onPressDo({self.respetenCuarentena()})
	}
		
	method  moverseHacia(direccion){ position = direccion }
    		
   	method agregarAgente() { game.addVisual(self) }
 
   	method mensaje() { return "Les traigo paz..."}
		
	method aislar() {    		
    	memoriaManzana.personas().filter({p=>p.presentaSintomas()}).forEach({p=>p.estaAislada(true)})	
    }
    
    method respetenCuarentena() {
    	memoriaManzana.personas().forEach({	p => p.respetaLaCuarentena(true) })
    }
}