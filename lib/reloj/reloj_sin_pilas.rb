class RelojSinPilas < Reloj
  def self.detenido_justo_ahora
    new(Time.now)
  end

  def initialize(ahora)
    super()
    @ahora = ahora
  end

  attr_reader :ahora

  def clonar
    self.class.new(@ahora)
  end

  def tic
    clonar.tic!
  end

  def tic!
    @ahora += 1
    self
  end

  def cit
    clonar.cit!
  end

  def cit!
    @ahora -= 1
    self
  end

  def avanzar_dias(dias)
    clonar.avanzar_dias!(dias)
  end

  def avanzar_dias!(dias)
    fecha = @ahora.to_date + dias
    @ahora = Time.new(fecha.year, fecha.month, fecha.day,
                      @ahora.hour, @ahora.min,
                      @ahora.sec + @ahora.subsec.to_r)
    self
  end

  def retroceder_dias(dias)
    avanzar_dias(-dias)
  end

  def retroceder_dias!(dias)
    avanzar_dias!(-dias)
  end

  def en!(momento)
    @ahora = momento.to_time
    self
  end

  def en_burbuja_temporal(&closure)
    el_anterior_ahora = @ahora
    begin
      closure.call
    ensure
      @ahora = el_anterior_ahora
    end
  end
end
