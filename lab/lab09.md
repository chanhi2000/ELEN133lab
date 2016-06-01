# lab09
Generating Periodic Signals and Modulation with Sinusoidal Signals


## OBJECTIVES:
In this laboratory, we will generate a sinusoidal signal output and then implement simple modulation with a cosine wave. For a single frequency input, this creates two different output frequencies which are the sum and difference frequencies. For a general audio signal it creates an output that is the sum of the input shifted up and the input shifted down by the cosine frequency.

## BACKGROUND:
Several methods can be used to generate a sinusoidal waveform. Four are briefly described here.
- A normalized frequency $$0\leq\omega_0<2\pi$$ can be specified and then a general function to compute arbitrary cosine values forcos(ω0n) can compute each output sample. This may require too much computation for each sample in a real-time system implementation.
- The $$z$$-transform for a cosine function multiplied by a unit step function, 
$$
h[n]=\cos{\left(\omega_0n\right)}\mu[n]
$$
is 
$$
H(z)=\frac{1−\cos{\left(\omega_0\right)}z^{-1}}{1−2\cos{\left(\omega_0\right)}z^{-1}+z^{-2}}
$$
Since the impulse response of this second order filter would be $$h[n]$$, each output would only require the computation of a second order system. After two steps of initialization, the difference equation for this system function implements the trigonometric identity:
$$
\cos{\left(\omega_0n\right)}= 2\cos{\left(\omega_0\right)}\cos{\left(\omega_0(n-1)\right)}+\cos{\left(\omega_0(n-2)\right)}.
$$
- Alternatively, new values of both $$\cos{\left(\omega_0n\right)}$$ and $$\sin{\left(\omega_0n\right)}$$ could be updated from the previous values $$\cos{\left(\omega_0(n-1)\right)}$$ and $$\sin{\left(\omega_0(n-1)\right)}$$ at each iteration using the equations below. To implement this rotation, only the values of $$\cos{\left(\omega_0\right)}$$ and $$\sin{\left(\omega_0\right)}$$ are needed. Each new set of values would require 4 multiplies.
$$

$$
cos(ω0n)=cos(ω0 )cos(ω0(n−1))−sin(ω0 )sin(ω0(n−1))
sin(ω0n)=sin(ω0 )cos(ω0(n−1))+cos(ω0 )sin(ω0(n−1))
- A table of sampled values of a single period of a sine could be stored and an index into that table could be used to retrieve values close to the desired value. This method will be tested in the Prelab. Interpolation from the table and floating point time increments can improve accuracy.