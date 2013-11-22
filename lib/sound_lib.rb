require "sound_lib/version"
include Math

#class SoundLib
  def sinc(num)
    if num == 0
      num = 1
    elsif num != 0
      num = sin(num) / num
    end

    return num
  end

  def hanning(wave, j)
    p = 2 * PI / (j - 1)
    wave.length.times do |n|
      co = 0.5 - cos(n * p) * 0.5
      wave[n] = wave[n] * co
    end

    return wave
  end

  def hamming(wave, j)
    p = 2 * PI / (j - 1)
    wave.length.times do |n|
      co = 0.54 - cos(n * p) * 0.46
      wave[n] = wave[n] * co
    end

    return wave
  end

  def fir_lpf(fe, dn, b, w)
    offset = dn / 2

    (-offset).upto(offset) do |n|
      b[offset + n] = 2.0 * fe * sinc(2.0 * PI * fe * n) 
    end

    (dn + 1).times do |n|
      b[n] *= w[n]
    end
  end

  def fir_hpf(fe, dn, b, w)
    offset = dn / 2

    (-offset).upto(offset) do |n|
      b[offset + n] = sinc(PI * n) - 2.0 * fe * sinc(2.0 * PI * fe * n)
    end

    (dn + 1).times do |n|
      b[n] *= w[n]
    end
  end

  def fir_bpf(fe, fe2, dn, b, w)
    offset = dn / 2

    (-offset).upto(offset) do |n|
      b[offset + n] = 2.0 * fe2 * sinc(2.0 * PI * fe2 * n) - 2.0 * fe * sinc(2.0 * PI * fe * n)
    end

    (dn + 1).times do |n|
      b[n] *= w[n]
    end
  end

  def fir_bef(fe, fe2, dn, b, w)
    offset = dn / 2

    (-offset).upto(offset) do |n|
      b[offset + n] = sinc(PI * n) - 2.0 * fe2 * sinc(2.0 * PI * fe2 * n) + 2.0 * fe * sinc(2.0 * PI * fe * n)
    end

    (dn + 1).times do |n|
      b[n] *= w[n]
    end
  end

  include Math

  def dft(real)
    num = real.length
    temp_real = Array.new(num, 0)
    temp_image = Array.new(num, 0)

    d = 2.0 * PI / num
    num.times do |m|
      num.times {|n|
        temp_real[m] += real[n] * cos(d * m * n)
        temp_image[m] += real[n] * sin(d * m * n) * (-1)
      }
    end

    return [temp_real, temp_image]
  end 

  def idft(real, image)
    num = real.length
    temp_real = Array.new(num, 0)
    temp_image = Array.new(num, 0)

    d = 2.0 * PI / num

    num.times do |m|
      num.times {|n|
        real[m] += real[n] * cos(d * n) - image[n] * sin(d * n)
        image[m] += real[n] * sin(d * n) + image[n] * cos(d * n)
        temp_real[m] += real[n] * cos(d * m * n) - image[n] * sin(d * m * n)
        temp_real[m] += image[n] * cos(d * m * n) + real[n] * sin(d * m * n)
      }

      temp_real[m] /= num
      temp_image[m] /= num
    end

    return [temp_real, temp_image]
  #end 
end
