RSpec.describe(RelojConPilas) {
  context("#ahora") {
    it("retorna un objeto de tipo Time") {
      expect(subject.ahora).to be_a(Time)
    }

    it("las horas retornadas son siempre las actuales") {
      expect(subject.ahora).to be < subject.ahora
    }
  }

  context("#hoy") {
    it("retorna la fecha de hoy") {
      expect(subject.hoy).to eq(Date.today)
    }
  }
}
