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
