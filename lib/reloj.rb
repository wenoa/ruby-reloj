require "date"

class Reloj
  VERSION = "0.0.0".freeze

  # :nocov:
  def ahora
    raise(NotImplementedError)
  end
  # :nocov:

  def hoy
    ahora.to_date
  end

  def ayer
    hoy - 1
  end

  def anteayer
    ayer - 1
  end

  def mañana
    hoy + 1
  end

  def pasado_mañana
    mañana + 1
  end
end

require_relative "reloj/reloj_con_pilas"
require_relative "reloj/reloj_sin_pilas"
