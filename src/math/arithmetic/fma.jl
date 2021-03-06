function fma(a::T, b::T, c::T) where {F<:IEEEFloat, T<:DoubleFloat{F}}
    hi, lo = fma_2(a, b, c)
    return DoubleFloat(hi, lo)
end

function fma_4(a::T, b::T, c::T) where {F<:IEEEFloat, T<:DoubleFloat{F}}
    c_hi = HI(c) * onehalf(F)
    c_lo = LO(c) * onehalf(F)

    fma1 = fma(HI(a), HI(b), c_hi)
    fma2 = fma(HI(a), LO(b), c_hi)
    fma3 = fma(LO(a), HI(b), c_lo)
    fma4 = fma(LO(a), LO(b), c_lo)

    return add_4(fma1, fma2, fma3, fma4)
end

function fma_(a::T, b::T, c::T) where {F<:IEEEFloat, T<:DoubleFloat{F}}
    c_hi = HI(c) * half(F)
    c_lo = LO(c) * half(F)

    fma1 = fma(HI(a), HI(b), c_hi)
    fma2 = fma(HI(a), LO(b), c_hi)
    fma3 = fma(LO(a), HI(b), c_lo)
    fma4 = fma(LO(a), LO(b), c_lo)

    return add_3(fma1, fma2, fma3, fma4)
end

fma_3(a::T, b::T, c::T) where {F<:IEEEFloat, T<:DoubleFloat{F}} =
    fma_(a, b, c)

function fma_2(a::T, b::T, c::T) where {F<:IEEEFloat, T<:DoubleFloat{F}}
    c_hi = halfx(HI(c))
    c_lo = halfx(LO(c))

    fma1 = fma(HI(a), HI(b), c_hi)
    fma2 = fma(HI(a), LO(b), c_hi)
    fma3 = fma(LO(a), HI(b), c_lo)
    fma4 = fma(LO(a), LO(b), c_lo)

    return add_2(fma1, fma2, fma3, fma4)
end
