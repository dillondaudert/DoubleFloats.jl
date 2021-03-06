Float64(x::DoubleFloat{T}) where {T<:IEEEFloat} = Float64(HI(x))
Float32(x::DoubleFloat{T}) where {T<:IEEEFloat} = Float32(Float64(x))
Float16(x::DoubleFloat{T}) where {T<:IEEEFloat} = Float16(Float64(x))

Int128(x::DoubleFloat{T}) where {T<:IEEEFloat} = Int128(round(Base.BigInt, Base.BigFloat(HI(x)) + Base.BigFloat(LO(x))))
Int64(x::DoubleFloat{T}) where {T<:IEEEFloat} = Int64(round(Base.BigInt, Base.BigFloat(HI(x)) + Base.BigFloat(LO(x))))
Int32(x::DoubleFloat{T}) where {T<:IEEEFloat} = Int32(round(Base.BigInt, Base.BigFloat(HI(x)) + Base.BigFloat(LO(x))))
Int16(x::DoubleFloat{T}) where {T<:IEEEFloat} = Int16(round(Base.BigInt, Base.BigFloat(HI(x)) + Base.BigFloat(LO(x))))
Int8(x::DoubleFloat{T}) where {T<:IEEEFloat} = Int8(round(Base.BigInt, Base.BigFloat(HI(x)) + Base.BigFloat(LO(x))))

Base.BigFloat(x::DoubleFloat{T}) where {T<:AbstractFloat} = Base.BigFloat(HI(x)) + Base.BigFloat(LO(x))

Base.BigFloat(x::DoubleFloat{DoubleFloat{T}}) where {T<:IEEEFloat} =
    Base.BigFloat(HI(HI(x))) + Base.BigFloat(LO(HI(x))) + Base.BigFloat(HI(LO(x))) + Base.BigFloat(LO(LO(x)))


for (F,D) in ((:(Base.Float64), :Double64), (:(Base.Float32), :Double32), (:(Base.Float16), :Double16))
  @eval begin
    function $D(x::Base.BigFloat)
        hi = $F(x)
        lo = $F(x - hi)
        return $D(hi, lo)
    end
    $D(x::Base.BigInt) = $D(Base.BigFloat(x))
  end
end


function DoubleFloat{DoubleFloat{T}}(x::Base.BigFloat) where {T<:IEEEFloat}
    hihi = T(x)
    hilo = T(x - hihi)
    lohi = T(x - hihi - hilo)
    lolo = T(x - hihi - hilo - lohi)
    hi = DoubleFloat(hihi, hilo)
    lo = DoubleFloat(lohi, lolo)
    return DoubleFloat(hi, lo)
end
DoubleFloat{DoubleFloat{T}}(x::Base.BigInt) where {T<:IEEEFloat} =
    DoubleFloat{DoubleFloat{T}}(Base.BigFloat(x))

DoubleFloat{T}(x::DoubleFloat{DoubleFloat{T}}) where {T<:IEEEFloat} = HI(x)
DoubleFloat{DoubleFloat{T}}(x::DoubleFloat{T}) where {T<:IEEEFloat} =
    DoubleFloat{DoubleFloat{T}}(x, DoubleFloat(zero(T)))

Double64(x::Irrational{S}) where {S} = Double64(Base.BigFloat(x))
Double32(x::Irrational{S}) where {S} = Double32(Base.BigFloat(x))
Double16(x::Irrational{S}) where {S} = Double16(Base.BigFloat(x))
