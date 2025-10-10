// Superclase ---------------------------------------------------------------------------------------------

class Nave {
	var velocidad       = 0
	var velocidadMaxima = 300000

	method velocidad() {
		return velocidad
	}

	method propulsar() {
		velocidad = (velocidad + 20000).min(velocidadMaxima)
	}

	method recibirAmenaza() {
	  
	}

	method prepararParaViajar() {
		velocidad = (velocidad + 15000).min(velocidadMaxima)
	}

	method encontrarEnemigo() {
		self.recibirAmenaza()
		self.propulsar()
	}
}

// Subclases: Naves de carga ------------------------------------------------------------------------------

class NaveDeCarga inherits Nave {
	var property carga = 0

	method sobrecargada() = carga > 100000

	method excedidaDeVelocidad() = velocidad > 100000

	override method recibirAmenaza() {
		carga = 0
	}

}

class NaveDeCargaRadiactiva inherits NaveDeCarga {
	var estaSelladaAlVacio = false

	method estaSelladaAlVacio() {
		return estaSelladaAlVacio
	}
	
	override method recibirAmenaza() {
		velocidad = 0
	}

	method sellarAlVacio() {
		estaSelladaAlVacio = true
	}

	override method prepararParaViajar() {
		super()
		self.sellarAlVacio()
	}
	
}

// Subclase: Nave de pasajeros ----------------------------------------------------------------------------

class NaveDePasajeros inherits Nave {
	var property alarma = false
	const cantidadDePasajeros = 0

	method tripulacion() = cantidadDePasajeros + 4

	method velocidadMaximaLegal() = 300000 / self.tripulacion() - if (cantidadDePasajeros > 100) 200 else 0

	method estaEnPeligro() = velocidad > self.velocidadMaximaLegal() or alarma

	override method recibirAmenaza() {
		alarma = true
	}

}

// Subclase: Nave de combate ------------------------------------------------------------------------------

class NaveDeCombate  inherits Nave {
	var property modo = reposo
	const property mensajesEmitidos = []

	method emitirMensaje(mensaje) {
		mensajesEmitidos.add(mensaje)
	}
	
	method ultimoMensaje() = mensajesEmitidos.last()

	method estaInvisible() = velocidad < 10000 and modo.invisible()

	override method recibirAmenaza() {
		modo.recibirAmenaza(self)
	}

	override method prepararParaViajar() {
		super()
		modo.prepararParaViajar(self)
	}
}

	// Modos de nave de combate

object reposo {

	method invisible() = false

	method recibirAmenaza(nave) {
		nave.emitirMensaje("¡RETIRADA!")
	}

	method prepararParaViajar(nave) {
		nave.emitirMensaje("Saliendo en misión")
		nave.modo(ataque)
	}
}

object ataque {

	method invisible() = true

	method recibirAmenaza(nave) {
		nave.emitirMensaje("Enemigo encontrado")
	}

	method prepararParaViajar(nave) {
		nave.emitirMensaje("Volviendo a la base")
	}
}
