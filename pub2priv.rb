#!/usr/bin/env ruby
#convert a supplied public key to a private key
#This assumes a reasonably weak key length otherwise the loop will do math longer than you'll want to wait.
#@atucom

require 'openssl'
#written by rosettacode
#based on pseudo code from http://en.wikipedia.org/wiki/Extended_Euclidean_algorithm#Iterative_method_2 and from translating the python implementation.
def extended_gcd(a, b)
  last_remainder, remainder = a.abs, b.abs
  x, last_x, y, last_y = 0, 1, 1, 0
  while remainder != 0
    last_remainder, (quotient, remainder) = remainder, last_remainder.divmod(remainder)
    x, last_x = last_x - quotient*x, x
    y, last_y = last_y - quotient*y, y
  end
 
  return last_remainder, last_x * (a < 0 ? -1 : 1)
end
 
def invmod(e, et)
  g, x = extended_gcd(e, et)
  if g != 1
    raise 'The maths are broken!'
  end
  x % et
end

#read in public key
pub_key = File.read(ARGV[0])
pub_key = OpenSSL::PKey::RSA.new(pub_key)
n = OpenSSL::PKey::RSA.new(pub_key).n.to_s.to_i
e = OpenSSL::PKey::RSA.new(pub_key).e.to_s.to_i
q = 0

Math.sqrt(n).to_i.times do |i|
  next if i == 0 or i == 1
  if n % i == 0
    q = i
  end
end

p = n/q
d = invmod(e,((p-1)*(q-1)))
dmp1 = d % (p-1)
dmq1 = d % (q-1)
iqmp = invmod(q,p)


priv_key = OpenSSL::PKey::RSA::new
priv_key.e = e
priv_key.d = d
priv_key.n = n
priv_key.p = p
priv_key.q = q
priv_key.dmp1 = dmp1
priv_key.dmq1 = dmq1
priv_key.iqmp = iqmp

puts priv_key