# Ported to Nim by Joshua "Skrylar" Cearley

# Doinked from Emmanuel Oga's easing library for Lua, who in turn
# doinked it from Robert Penner.

# Disclaimer for Robert Penner's Easing Equations license:
# TERMS OF USE - EASING EQUATIONS
# Open source under the BSD License.
# Copyright © 2001 Robert Penner
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:

     # * Redistributions of source code must retain the above copyright
     # notice, this list of conditions and the following disclaimer.

     # * Redistributions in binary form must reproduce the above
     # copyright notice, this list of conditions and the following
     # disclaimer in the documentation and/or other materials provided
     # with the distribution.

     # * Neither the name of the author nor the names of contributors
     # may be used to endorse or promote products derived from this
     # software without specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import math

# For all easing functions:
# t = elapsed time
# b = begin
# c = change == ending - beginning
# d = duration (total time)
# a: amplitud
# p: period

proc linear*(t, b, c, d: SomeReal): SomeReal =
  return c * t / d + b

proc inQuad*(t, b, c, d: SomeReal): SomeReal =
  t = t / d
  return c * pow(t, 2) + b

proc outQuad*(t, b, c, d: SomeReal): SomeReal =
  t = t / d
  return -c * t * (t - 2) + b

proc inOutQuad*(t, b, c, d: SomeReal): SomeReal =
  t = t / d * 2
  if t < 1:
    return c / 2 * pow(t, 2) + b
  else:
    return -c / 2 * ((t - 1) * (t - 3) - 1) + b

proc outInQuad*(t, b, c, d: SomeReal): SomeReal =
  if t < d / 2:
    return outQuad(t * 2, b, c / 2, d)
  else:
    return inQuad((t * 2) - d, b + c / 2, c / 2, d)

proc inCubic* (t, b, c, d: SomeReal): SomeReal =
  t = t / d
  return c * pow(t, 3) + b

proc outCubic*(t, b, c, d: SomeReal): SomeReal =
  t = t / d - 1
  return c * (pow(t, 3) + 1) + b

proc inOutCubic*(t, b, c, d: SomeReal): SomeReal =
  t = t / d * 2
  if t < 1:
    return c / 2 * t * t * t + b
  else:
    t = t - 2
    return c / 2 * (t * t * t + 2) + b

proc outInCubic*(t, b, c, d: SomeReal): SomeReal =
  if t < d / 2:
    return outCubic(t * 2, b, c / 2, d)
  else:
    return inCubic((t * 2) - d, b + c / 2, c / 2, d)

proc inQuart*(t, b, c, d: SomeReal): SomeReal =
  t = t / d
  return c * pow(t, 4) + b

proc outQuart*(t, b, c, d: SomeReal): SomeReal =
  t = t / d - 1
  return -c * (pow(t, 4) - 1) + b

proc inOutQuart*(t, b, c, d: SomeReal): SomeReal =
  t = t / d * 2
  if t < 1:
    return c / 2 * pow(t, 4) + b
  else:
    t = t - 2
    return -c / 2 * (pow(t, 4) - 2) + b

proc outInQuart*(t, b, c, d: SomeReal): SomeReal =
  if t < d / 2:
    return outQuart(t * 2, b, c / 2, d)
  else:
    return inQuart((t * 2) - d, b + c / 2, c / 2, d)

proc inQuint*(t, b, c, d: SomeReal): SomeReal =
  t = t / d
  return c * pow(t, 5) + b

proc outQuint*(t, b, c, d: SomeReal): SomeReal =
  t = t / d - 1
  return c * (pow(t, 5) + 1) + b

proc inOutQuint*(t, b, c, d: SomeReal): SomeReal =
  t = t / d * 2
  if t < 1:
    return c / 2 * pow(t, 5) + b
  else:
    t = t - 2
    return c / 2 * (pow(t, 5) + 2) + b

proc outInQuint*(t, b, c, d: SomeReal): SomeReal =
  if t < d / 2:
    return outQuint(t * 2, b, c / 2, d)
  else:
    return inQuint((t * 2) - d, b + c / 2, c / 2, d)

proc inSine*(t, b, c, d: SomeReal): SomeReal =
  return -c * cos(t / d * (PI / 2)) + c + b

proc outSine*(t, b, c, d: SomeReal): SomeReal =
  return c * sin(t / d * (PI / 2)) + b

proc inOutSine*(t, b, c, d: SomeReal): SomeReal =
  return -c / 2 * (cos(PI * t / d) - 1) + b

proc outInSine*(t, b, c, d: SomeReal): SomeReal =
  if t < d / 2:
    return outSine(t * 2, b, c / 2, d)
  else:
    return inSine((t * 2) - d, b + c / 2, c / 2, d)

proc inExpo*(t, b, c, d: SomeReal): SomeReal =
  if t == 0:
    return b
  else:
    return c * pow(2, 10 * (t / d - 1)) + b - c * 0.001

proc outExpo*(t, b, c, d: SomeReal): SomeReal =
  if t == d:
    return b + c
  else:
    return c * 1.001 * (-pow(2, -10 * t / d) + 1) + b

proc inOutExpo*(t, b, c, d: SomeReal): SomeReal =
  t = t / d * 2
  if t < 1:
    return c / 2 * pow(2, 10 * (t - 1)) + b - c * 0.0005
  else:
    t = t - 1
    return c / 2 * 1.0005 * (-pow(2, -10 * t) + 2) + b

proc outInExpo*(t, b, c, d: SomeReal): SomeReal =
  if t < d / 2:
    return outExpo(t * 2, b, c / 2, d)
  else:
    return inExpo((t * 2) - d, b + c / 2, c / 2, d)

proc inCirc*(t, b, c, d: SomeReal): SomeReal =
  t = t / d
  return(-c * (sqrt(1 - pow(t, 2)) - 1) + b)

proc outCirc*(t, b, c, d: SomeReal): SomeReal =
  t = t / d - 1
  return(c * sqrt(1 - pow(t, 2)) + b)

proc inOutCirc*(t, b, c, d: SomeReal): SomeReal =
  t = t / d * 2
  if t < 1:
    return -c / 2 * (sqrt(1 - t * t) - 1) + b
  else:
    t = t - 2
    return c / 2 * (sqrt(1 - t * t) + 1) + b

proc outInCirc*(t, b, c, d: SomeReal): SomeReal =
  if t < d / 2:
    return outCirc(t * 2, b, c / 2, d)
  else:
    return inCirc((t * 2) - d, b + c / 2, c / 2, d)

# Elastic {{{

proc inElastic*(t, b, c, d, a, p: SomeReal): SomeReal =
  t = t / d
  var s: SomeReal

  if not a or a < abs(c):
    a = c
    s = p / 4
  else:
    s = p / (2 * PI) * arcsin(c/a)

  t = t - 1

  return -(a * pow(2, 10 * t) * sin((t * d - s) * (2 * PI) / p)) + b

proc outElastic*(t, b, c, d, a, p: SomeReal): SomeReal =
  t = t / d
  var s: SomeReal

  if not a or a < abs(c):
    a = c
    s = p / 4
  else:
    s = p / (2 * PI) * arcsin(c/a)

  return a * pow(2, -10 * t) * sin((t * d - s) * (2 * PI) / p) + c + b

proc inOutElastic*(t, b, c, d, a, p: SomeReal): SomeReal =
  t = t / d * 2
  var s: SomeReal

  if not a or a < abs(c):
    a = c
    s = p / 4
  else:
    s = p / (2 * PI) * arcsin(c / a)

  if t < 1:
    t = t - 1
    return -0.5 * (a * pow(2, 10 * t) * sin((t * d - s) * (2 * PI) / p)) + b
  else:
    t = t - 1
    return a * pow(2, -10 * t) * sin((t * d - s) * (2 * PI) / p ) * 0.5 + c + b

proc outInElastic*(t, b, c, d, a, p: SomeReal): SomeReal =
  if t < d / 2:
    return outElastic(t * 2, b, c / 2, d, a, p)
  else:
    return inElastic((t * 2) - d, b + c / 2, c / 2, d, a, p)

# }}} Elastic

proc inBack*(t, b, c, d, s: SomeReal): SomeReal =
  t = t / d
  return c * t * t * ((s + 1) * t - s) + b

proc outBack*(t, b, c, d, s: SomeReal): SomeReal =
  t = t / d - 1
  return c * (t * t * ((s + 1) * t + s) + 1) + b

proc inOutBack*(t, b, c, d, s: SomeReal): SomeReal =
  s = s * 1.525
  t = t / d * 2
  if t < 1:
    return c / 2 * (t * t * ((s + 1) * t - s)) + b
  else:
    t = t - 2
    return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b

proc outInBack*(t, b, c, d, s: SomeReal): SomeReal =
  if t < d / 2:
    return outBack(t * 2, b, c / 2, d, s)
  else:
    return inBack((t * 2) - d, b + c / 2, c / 2, d, s)

proc outBounce*(t, b, c, d: SomeReal): SomeReal =
  t = t / d
  if t < 1 / 2.75:
    return c * (7.5625 * t * t) + b
  elif t < 2 / 2.75:
    t = t - (1.5 / 2.75)
    return c * (7.5625 * t * t + 0.75) + b
  elif t < 2.5 / 2.75:
    t = t - (2.25 / 2.75)
    return c * (7.5625 * t * t + 0.9375) + b
  else:
    t = t - (2.625 / 2.75)
    return c * (7.5625 * t * t + 0.984375) + b

proc inBounce*(t, b, c, d: SomeReal): SomeReal =
  return c - outBounce(d - t, 0, c, d) + b

proc inOutBounce*(t, b, c, d: SomeReal): SomeReal =
  if t < d / 2:
    return inBounce(t * 2, 0, c, d) * 0.5 + b
  else:
    return outBounce(t * 2 - d, 0, c, d) * 0.5 + c * 0.5 + b

proc outInBounce*(t, b, c, d: SomeReal): SomeReal =
  if t < d / 2:
    return outBounce(t * 2, b, c / 2, d)
  else:
    return inBounce((t * 2) - d, b + c / 2, c / 2, d)

