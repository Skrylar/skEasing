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
  let t_hat = t / d
  return c * t_hat * t_hat + b

proc outQuad*(t, b, c, d: SomeReal): SomeReal =
  let t_hat = t / d
  return -c * t_hat * (t_hat - 2) + b

proc inOutQuad*(t, b, c, d: SomeReal): SomeReal =
  let t_hat = t / (d / 2)
  if t_hat < 1:
    return c / 2 * t_hat * t_hat + b
  else:
    return -c / 2 * ((t_hat - 1) * (t_hat - 3) - 1) + b

proc inCubic* (t, b, c, d: SomeReal): SomeReal =
  let t_hat = t / d
  return c * pow(t_hat, 3) + b

proc outCubic*(t, b, c, d: SomeReal): SomeReal =
  let t_hat = t / d - 1
  return c * (pow(t_hat, 3) + 1) + b

proc inOutCubic*(t, b, c, d: SomeReal): SomeReal =
  let t_hat = t / d * 2
  if t_hat < 1:
    return c / 2 * t_hat * t_hat * t_hat + b
  else:
    let t_hat = t_hat - 2
    return c / 2 * (t_hat * t_hat * t_hat + 2) + b

proc inQuart*(t, b, c, d: SomeReal): SomeReal =
  return c * pow(t / d, 4) + b

proc outQuart*(t, b, c, d: SomeReal): SomeReal =
  return -c * (pow(t / d - 1, 4) - 1) + b

proc inOutQuart*(t, b, c, d: SomeReal): SomeReal =
  let t_hat = t / (d / 2)
  if t_hat < 1:
    return c/2 * pow(t_hat, 4) + b
  else:
    return -c/2 * (pow(t_hat-2, 4) - 2) + b

proc inQuint*(t, b, c, d: SomeReal): SomeReal =
  return c * pow(t / d, 5) + b

proc outQuint*(t, b, c, d: SomeReal): SomeReal =
  return c * (pow(t / d - 1, 5) + 1) + b

proc inOutQuint*(t, b, c, d: SomeReal): SomeReal =
  let t_hat = t / (d / 2)
  if t_hat < 1:
    return c / 2 * pow(t_hat, 5) + b
  else:
    return c / 2 * (pow(t_hat - 2, 5) + 2) + b

proc inSine*(t, b, c, d: SomeReal): SomeReal =
  return -c * cos(t / d * (PI / 2)) + c + b

proc outSine*(t, b, c, d: SomeReal): SomeReal =
  return c * sin(t / d * (PI / 2)) + b

proc inOutSine*(t, b, c, d: SomeReal): SomeReal =
  return -c / 2 * (cos(PI * t / d) - 1) + b

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
  if t < d / 2:
    return inExpo((t * 2) - d, b + c / 2, c / 2, d)
  else:
    return outExpo(t * 2, b, c / 2, d)

proc inCirc*(t, b, c, d: SomeReal): SomeReal =
  let t_hat = t / d
  return(-c * (sqrt(1 - pow(t_hat, 2)) - 1) + b)

proc outCirc*(t, b, c, d: SomeReal): SomeReal =
  let t_hat = t / d - 1
  return(c * sqrt(1 - pow(t_hat, 2)) + b)

proc inOutCirc*(t, b, c, d: SomeReal): SomeReal =
  let t_hat = t / d * 2
  if t_hat < 1:
    return -c / 2 * (sqrt(1 - t_hat * t_hat) - 1) + b
  else:
    let t_hat = t_hat - 2
    return c / 2 * (sqrt(1 - t_hat * t_hat) + 1) + b

# Elastic {{{

proc inElastic*(t, b, c, d, a, p: SomeReal): SomeReal =
  let t_hat = t / d
  var s: SomeReal

  if not a or a < abs(c):
    a = c
    s = p / 4
  else:
    s = p / (2 * PI) * arcsin(c/a)

  let t_hat = t - 1

  return -(a * pow(2, 10 * t_hat) * sin((t_hat * d - s) * (2 * PI) / p)) + b

proc outElastic*(t, b, c, d, a, p: SomeReal): SomeReal =
  let t_hat = t / d
  var s: SomeReal

  if not a or a < abs(c):
    a = c
    s = p / 4
  else:
    s = p / (2 * PI) * arcsin(c/a)

  return a * pow(2, -10 * t_hat) * sin((t_hat * d - s) * (2 * PI) / p) + c + b

proc inOutElastic*(t, b, c, d, a, p: SomeReal): SomeReal =
  let t_hat = t / d * 2
  var s: SomeReal

  if not a or a < abs(c):
    a = c
    s = p / 4
  else:
    s = p / (2 * PI) * arcsin(c / a)

  if t < 1:
    let t_hat = t - 1
    return -0.5 * (a * pow(2, 10 * t_hat) * sin((t_hat * d - s) * (2 * PI) / p)) + b
  else:
    let t_hat = t - 1
    return a * pow(2, -10 * t_hat) * sin((t_hat * d - s) * (2 * PI) / p ) * 0.5 + c + b

proc outInElastic*(t, b, c, d, a, p: SomeReal): SomeReal =
  if t < d / 2:
    return outElastic(t * 2, b, c / 2, d, a, p)
  else:
    return inElastic((t * 2) - d, b + c / 2, c / 2, d, a, p)

# }}} Elastic

proc inBack*(t, b, c, d, s: SomeReal): SomeReal =
  let t_hat = t / d
  return c * t_hat * t_hat * ((s + 1) * t_hat - s) + b

proc outBack*(t, b, c, d, s: SomeReal): SomeReal =
  let t_hat = t / d - 1
  return c * (t_hat * t_hat * ((s + 1) * t_hat + s) + 1) + b

proc inOutBack*(t, b, c, d, s: SomeReal): SomeReal =
  s = s * 1.525
  let t_hat = t / d * 2
  if t < 1:
    return c / 2 * (t_hat * t_hat * ((s + 1) * t_hat - s)) + b
  else:
    let t_hat = t - 2
    return c / 2 * (t_hat * t_hat * ((s + 1) * t_hat + s) + 2) + b

proc outInBack*(t, b, c, d, s: SomeReal): SomeReal =
  if t < d / 2:
    return outBack(t * 2, b, c / 2, d, s)
  else:
    return inBack((t * 2) - d, b + c / 2, c / 2, d, s)

proc outBounce*(t, b, c, d: SomeReal): SomeReal =
  let t_hat = t / d
  if t < 1 / 2.75:
    return c * (7.5625 * t_hat * t_hat) + b
  elif t < 2 / 2.75:
    let t_hat = t - (1.5 / 2.75)
    return c * (7.5625 * t_hat * t_hat + 0.75) + b
  elif t < 2.5 / 2.75:
    let t_hat = t - (2.25 / 2.75)
    return c * (7.5625 * t_hat * t_hat + 0.9375) + b
  else:
    let t_hat = t - (2.625 / 2.75)
    return c * (7.5625 * t_hat * t_hat + 0.984375) + b

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

