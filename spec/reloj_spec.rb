RSpec.describe(Reloj) {
  subject(:reloj) {
    Class.new(Reloj) {
      def ahora
        Time.new(2026, 7, 17, 10, 30, 0)
      end
    }.new
  }

  context("#hoy") {
    it("retorna la fecha del momento actual") {
      expect(reloj.hoy).to eq(Date.new(2026, 7, 17))
    }
  }

  context("fechas relativas") {
    it("sabe cuándo fue ayer") {
      expect(reloj.ayer).to eq(Date.new(2026, 7, 16))
    }

    it("sabe cuándo fue anteayer") {
      expect(reloj.anteayer).to eq(Date.new(2026, 7, 15))
    }

    it("sabe cuándo es mañana") {
      expect(reloj.mañana).to eq(Date.new(2026, 7, 18))
    }

    it("sabe cuándo es pasado mañana") {
      expect(reloj.pasado_mañana).to eq(Date.new(2026, 7, 19))
    }
  }
}
