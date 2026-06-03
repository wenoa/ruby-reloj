RSpec.describe(RelojSinPilas) {
  subject(:reloj) { described_class.detenido_justo_ahora }

  context(".detenido_justo_ahora") {
    it("arranca en la hora del sistema") {
      antes = Time.now
      reloj = described_class.detenido_justo_ahora
      despues = Time.now
      expect(reloj.ahora).to be_between(antes, despues)
    }
  }

  context("#tic") {
    it("retorna un nuevo reloj adelantado un segundo, sin mutar el original") {
      momento = reloj.ahora
      expect(reloj.tic.ahora).to eq(momento + 1)
      expect(reloj.ahora).to eq(momento)
    }
  }

  context("#tic!") {
    it("avanza un segundo") {
      momento = reloj.ahora
      reloj.tic!
      expect(reloj.ahora).to eq(momento + 1)
    }
  }

  context("#cit") {
    it("retorna un nuevo reloj atrasado un segundo, sin mutar el original") {
      momento = reloj.ahora
      expect(reloj.cit.ahora).to eq(momento - 1)
      expect(reloj.ahora).to eq(momento)
    }
  }

  context("#cit!") {
    it("atrasa un segundo") {
      momento = reloj.ahora
      reloj.cit!
      expect(reloj.ahora).to eq(momento - 1)
    }
  }

  context("#avanzar_dias") {
    it("retorna un nuevo reloj adelantado la cantidad de días, sin mutar el original") {
      momento = reloj.ahora
      expect(reloj.avanzar_dias(3).hoy).to eq(Date.today + 3)
      expect(reloj.ahora).to eq(momento)
    }

    it("conserva la hora del día, hasta la fracción de segundo, al cambiar de día") {
      reloj = described_class.new(Time.new(2026, 7, 17, 10, 30, 45.5))
      expect(reloj.avanzar_dias(1).ahora).to eq(Time.new(2026, 7, 18, 10, 30, 45.5))
    }
  }

  context("#avanzar_dias!") {
    it("adelanta la cantidad de días indicada") {
      reloj.avanzar_dias!(3)
      expect(reloj.hoy).to eq(Date.today + 3)
    }
  }

  context("#retroceder_dias") {
    it("retorna un nuevo reloj atrasado la cantidad de días, sin mutar el original") {
      momento = reloj.ahora
      expect(reloj.retroceder_dias(2).hoy).to eq(Date.today - 2)
      expect(reloj.ahora).to eq(momento)
    }
  }

  context("#retroceder_dias!") {
    it("atrasa la cantidad de días indicada") {
      reloj.retroceder_dias!(2)
      expect(reloj.hoy).to eq(Date.today - 2)
    }
  }

  context("#en!") {
    context("reposiciona el reloj en el momento dado") {
      it("con un Date") {
        reloj.en!(Date.new(2020, 1, 1))
        expect(reloj.ahora).to eq(Time.new(2020, 1, 1, 0, 0, 0))
      }

      it("con un Time") {
        reloj.en!(Time.new(2020, 1, 1, 15, 30, 1))
        expect(reloj.ahora).to eq(Time.new(2020, 1, 1, 15, 30, 1))
      }
    }
  }

  context("#en_burbuja_temporal") {
    it("ejecuta el bloque y retorna el resultado") {
      expect(reloj.en_burbuja_temporal { :resultado }).to eq(:resultado)
    }

    it("restaura el ahora al finalizar el bloque") {
      momento = reloj.ahora
      reloj.en_burbuja_temporal { reloj.avanzar_dias!(10) }
      expect(reloj.ahora).to eq(momento)
    }

    it("restaura el ahora aunque el bloque falle") {
      momento = reloj.ahora
      expect {
        reloj.en_burbuja_temporal { raise("boom") }
      }.to raise_error("boom")
      expect(reloj.ahora).to eq(momento)
    }
  }

  context("al cruzar un límite de horario de verano") {
    let(:zona_con_horario_de_verano) {
      # Zona en formato POSIX con reglas fijas:
      #  - UTC-5 en invierno
      #  - UTC-4 en verano
      #  - Adelanta el 2º domingo de marzo
      #  - Atrasa el 1º domingo de noviembre.
      "XXX5YYY,M3.2.0,M11.1.0"
    }

    it("mantiene la misma hora del día en vez de sumar 24 horas exactas") {
      en_zona(zona_con_horario_de_verano) {
        # Arrancamos el 2026-03-07 10:30, un día antes del cambio de horario.
        reloj = described_class.new(Time.new(2026, 3, 7, 10, 30, 0))
        expect(reloj.ahora.utc_offset).to eq(-5 * 3600)

        reloj.avanzar_dias!(1)

        # Al día siguiente ya rige el horario de verano, pero siguen siendo las 10:30.
        expect(reloj.hoy).to eq(Date.new(2026, 3, 8))
        expect(reloj.ahora.utc_offset).to eq(-4 * 3600)
        expect(reloj.ahora.hour).to eq(10)
        expect(reloj.ahora.min).to eq(30)
      }
    }
  }
}
