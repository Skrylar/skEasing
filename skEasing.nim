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

import math, fenv

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

# Damped spring motion

#  Copyright (c) 2008-2012 Ryan Juckett http://www.ryanjuckett.com/
#
#  This software is provided 'as-is', without any express or implied
#  warranty. In no event will the authors be held liable for any
#  damages arising from the use of this software.
#
#  Permission is granted to anyone to use this software for any purpose,
#  including commercial applications, and to alter it and redistribute
#  it freely, subject to the following restrictions:
#
#  1. The origin of this software must not be misrepresented; you
#  must not
#     claim that you wrote the original software. If you use this
#     software in a product, an acknowledgment in the product
#     documentation would be appreciated but is not required.
#
#  2. Altered source versions must be plainly marked as such, and must
#  not be
#     misrepresented as being the original software.
#
#  3. This notice may not be removed or altered from any source
#     distribution.

# Sk: Consider the following code an 'altered source version' in
# its entirety

type
  DampedSpringCoefficients*[T:SomeReal] = object
    ## Caches coefficients so that multiple springs with
    ## the same parameters may be used without re-running
    ## trigonometry calls.
    posPosCoef, posVelCoef: T
    velPosCoef, velVelCoef: T

proc init*[T:SomeReal] (self: var DampedSpringCoefficients[T];
            delta_time,
            desired_angular_frequency,
            desired_damping_ratio: T) =
  ## Performs (somewhat nontrivial) calculations to prepare
  ## the motion of a damped spring. Once initialized, you
  ## may update any spring with identical properties with
  ## `update` using the same object.

  # clamping
  let damping_ratio = if desired_damping_ratio < 0.0: 0.0 else: desired_damping_ratio
  let angular_frequency = if desired_angular_frequency < 0.0: 0.0 else: desired_angular_frequency

  # special case: no angular frequency
  if angular_frequency < epsilon(T):
    self.posPosCoef = 1.0
    self.posVelCoef = 0.0
    self.velPosCoef = 0.0
    self.velVelCoef = 1.0
    return

  if damping_ratio > 1.0 + epsilon(T): # over-damped
    let za = -angular_frequency * damping_ratio
    let zb = angular_frequency * sqrt(damping_ratio * damping_ratio - 1.0)
    let z1 = za - zb
    let z2 = za + zb
    let e1 = exp(z1 * delta_time)
    let e2 = exp(z2 * delta_time)
    let inv_two_zb = 1.0 / (2.0 * zb)
    let e1_over_twozb = e1 * inv_two_zb
    let e2_over_twozb = e2 * inv_two_zb
    let z1e1_over_twozb = z1 * e1_over_twozb
    let z2e2_over_twozb = z2 * e2_over_twozb
    self.posPosCoef = e1_over_twozb * z2 - z2e2_over_twozb + e2
    self.posVelCoef = -e1_over_twozb + e2_over_twozb
    self.velPosCoef = (z1e1_over_twozb - z2e2_over_twozb + e2) * z2
    self.velVelCoef = -z1e1_over_twozb + z2e2_over_twozb
  elif damping_ratio < 1.0 - epsilon(T): # under-damped
    let omega_zeta = angular_frequency * damping_ratio
    let alpha = angular_frequency * sqrt(1.0 - damping_ratio * damping_ratio)
    let exp_term = exp(-omega_zeta * delta_time)
    let cos_term = cos(alpha * delta_time)
    let sin_term = sin(alpha * delta_time)
    let inv_alpha = 1.0 / alpha
    let exp_sin = exp_term * sin_term
    let exp_cos = exp_term * cos_term
    let exp_omega_zeta_sin_over_alpha = exp_term * omega_zeta * sin_term * inv_alpha
    self.posPosCoef = exp_cos + exp_omega_zeta_sin_over_alpha
    self.posVelCoef = exp_sin * inv_alpha
    self.velPosCoef = -exp_sin * alpha - omega_zeta * exp_omega_zeta_sin_over_alpha
    self.velVelCoef = exp_cos - exp_omega_zeta_sin_over_alpha
  else: # critically damped
    let exp_term = exp(-angular_frequency * delta_time)
    let time_exp = delta_time * exp_term
    let time_exp_freq = time_exp * angular_frequency
    self.posPosCoef = time_exp_freq + exp_term
    self.posVelCoef = time_exp
    self.velPosCoef = -angular_frequency * time_exp_freq
    self.velVelCoef = -time_exp_freq + exp_term

# XXX is there a performance implication to not using ref/var here?
proc update* [T: SomeReal] (self: DampedSpringCoefficients[T];
              position, velocity: var T;
              target: T) =
  let old_pos = position - target
  let old_vel = velocity
  position = old_pos * self.posPosCoef + old_vel * self.posVelCoef + target
  velocity = old_pos * self.velPosCoef + old_vel * self.velVelCoef

