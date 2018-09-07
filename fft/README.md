Recursive FFT module. I have no idea if this works at all, but it compiles and spits out green numbers in modelsim.

Action list:
- [x] Inspect code to verify correct FFT operation - [Online FFT Calculator](http://scistatcalc.blogspot.com/2013/12/fft-calculator.html)
- [ ] Automatically test with known input/ output pairs - for big files and at various configurations
- [ ] Create weight and reversed bit order lookup tables with python script - optimise for repeat values
- [ ] Optimise for real hardware, particularly DE-0 Nano
