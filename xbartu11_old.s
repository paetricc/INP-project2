; Vernamova sifra na architekture DLX
; Tomas Bartu xbartu11
; povolene registry: r1-r11-r17-r19-r22-r0

        .data 0x04          ; zacatek data segmentu v pameti
login:  .asciiz "xaaaau11"  ; <-- nahradte vasim loginem
cipher: .space 9 ; sem ukladejte sifrovane znaky (za posledni nezapomente dat 0)

        .align 2            ; dale zarovnavej na ctverice (2^2) bajtu
laddr:  .word login         ; 4B adresa vstupniho textu (pro vypis)
caddr:  .word cipher        ; 4B adresa sifrovaneho retezce (pro vypis)

        .text 0x40          ; adresa zacatku programu v pameti
        .global main        ; 

main:   ; sem doplnte reseni Vernamovy sifry dle specifikace v zadani
	lb r11, login+1(r0)
	subi r11, r11, 96	; o kolik pujdeme do plusu	
	addi r1, r0, 0		; counter

for1:
	lb r22, login(r1)	; ulozime znak do registru
	add r22, r22, r11	; pricteme k nemu pozadovanou hodnotu

	slei r17, r22, 122
	bnez r17, endif1
	nop
	nop

	subi r19, r22, 122
	addi r22, r19, 96
	
  endif1:
	sb cipher(r1), r22	; upravenou hodnotu vlozime zpet na pozici
	addi r1, r1, 2		; pricteme do countru 2
	slti r17, r1, 8 	
	bnez r17, for1
	nop
	nop

	lb r11, login+2(r0)
	subi r11, r11, 96
	addi r1, r0, 1

for2:
	lb r22, login(r1)	; ulozime znak do registru
	sub r22, r22, r11	; odecteme k nemu pozadovanou hodnotu

	sgei r17, r22, 97
	bnez r17, endif2
	nop
	nop

	addi r17, r0, 96
	sub r22, r17, r22
	addi r17, r0, 122
	sub r22, r17, r22
	
 endif2:
	sb cipher(r1), r22	; upravenou hodnotu vlozime zpet na pozici
	addi r1, r1, 2		; pricteme do countru 2
	slti r17, r1, 8 	
	bnez r17, for2
	nop
	nop

	addi r1, r0, 0
	sb cipher+6(r0), r1
	
end:    addi r14, r0, caddr ; <-- pro vypis sifry nahradte laddr adresou caddr
        trap 5  ; vypis textoveho retezce (jeho adresa se ocekava v r14)
        trap 0  ; ukonceni simulace
