#!/usr/bin/env python


# Parses Aborption Spectrum and Transient Absorption Spectrum
# data from Orca 5.0.4 Calculation TD-DFT calculation.

### Note that this may only work when the DOTRANS ALL tag is 
### included in the calculation.  I haven't tested this without
### that tag.

#############################################################
# Uses a, or multiple, .out files from an ORCA calculation
#
#############################################################
# Generates a text file with the absorpation spectra data, 
# that can be read in by Matlab with a .mlab extension.
# Also generates a numpy array with the transition dipole
# moments.
#
# FIXME Talk to Nikita about prefered format for numpy array
#############################################################


import os
import sys
import numpy as np
from scipy.io import savemat

_BUILTIN_FLOAT = float

def float(number: str) -> float:
    """Convert a string to a float."""

    if list(set(number)) == ["*"]:
        return np.nan

    return _BUILTIN_FLOAT(number.replace("D", "E"))

def convertor(value: float, fromunits: str, tounits: str) -> float:
    """Convert from one set of units to another.

    Sources:
        NIST 2010 CODATA (http://physics.nist.gov/cuu/Constants/index.html)
        Documentation of GAMESS-US or other programs as noted
    """

    _convertor = {
        "time_au_to_fs": lambda x: x * 0.02418884,
        "fs_to_time_au": lambda x: x / 0.02418884,
        "Angstrom_to_bohr": lambda x: x * 1.8897261245,
        "bohr_to_Angstrom": lambda x: x * 0.5291772109,
        "wavenumber_to_eV": lambda x: x / 8065.54429,
        "wavenumber_to_hartree": lambda x: x / 219474.6313708,
        "wavenumber_to_kcal/mol": lambda x: x / 349.7550112,
        "wavenumber_to_kJ/mol": lambda x: x / 83.5934722814,
        "wavenumber_to_nm": lambda x: 1e7 / x,
        "wavenumber_to_Hz": lambda x: x * 29.9792458,
        "eV_to_wavenumber": lambda x: x * 8065.54429,
        "eV_to_hartree": lambda x: x / 27.21138505,
        "eV_to_kcal/mol": lambda x: x * 23.060548867,
        "eV_to_kJ/mol": lambda x: x * 96.4853364596,
        "hartree_to_wavenumber": lambda x: x * 219474.6313708,
        "hartree_to_eV": lambda x: x * 27.21138505,
        "hartree_to_kcal/mol": lambda x: x * 627.50947414,
        "hartree_to_kJ/mol": lambda x: x * 2625.4996398,
        "kcal/mol_to_wavenumber": lambda x: x * 349.7550112,
        "kcal/mol_to_eV": lambda x: x / 23.060548867,
        "kcal/mol_to_hartree": lambda x: x / 627.50947414,
        "kcal/mol_to_kJ/mol": lambda x: x * 4.184,
        "kJ/mol_to_wavenumber": lambda x: x * 83.5934722814,
        "kJ/mol_to_eV": lambda x: x / 96.4853364596,
        "kJ/mol_to_hartree": lambda x: x / 2625.49963978,
        "kJ/mol_to_kcal/mol": lambda x: x / 4.184,
        "nm_to_wavenumber": lambda x: 1e7 / x,
        # Taken from GAMESS docs, "Further information",
        # "Molecular Properties and Conversion Factors"
        "Debye^2/amu-Angstrom^2_to_km/mol": lambda x: x * 42.255,
        # Conversion for charges and multipole moments.
        "e_to_coulomb": lambda x: x * 1.602176565 * 1e-19,
        "e_to_statcoulomb": lambda x: x * 4.80320425 * 1e-10,
        "coulomb_to_e": lambda x: x * 0.6241509343 * 1e19,
        "statcoulomb_to_e": lambda x: x * 0.2081943527 * 1e10,
        "ebohr_to_Debye": lambda x: x * 2.5417462300,
        "ebohr2_to_Buckingham": lambda x: x * 1.3450341749,
        "ebohr2_to_Debye.ang": lambda x: x * 1.3450341749,
        "ebohr3_to_Debye.ang2": lambda x: x * 0.7117614302,
        "ebohr4_to_Debye.ang3": lambda x: x * 0.3766479268,
        "ebohr5_to_Debye.ang4": lambda x: x * 0.1993134985,
        "hartree/bohr2_to_mDyne/angstrom": lambda x: x * 8.23872350 / 0.5291772109,
    }

    return _convertor[f"{fromunits}_to_{tounits}"](value)




# Determine the number of States that Absorption Spectra was calculated for
def number_of_roots(filename):
    """ Find the number of excited states in ORCA calculation for
    absorption spectra.  Also determine the location of a set string
    that indicates the beginning of the absorption spectra data.
    
    'ABSORPTION SPECTRUM VIA TRANSITION ELECTRIC DIPOLE MOMENTS' """
    
    with open(filename, 'r') as f:
        line = f.readlines()
    
    k=[]
    # Determine number of calculated States
    for i, j in enumerate(line):
        if 'ORBITAL ENERGIES' in j:
            h=i
        if 'Number of roots to be determined' in j:
            NRoots = int(j.split()[-1])
        if 'ABSORPTION SPECTRUM VIA TRANSITION ELECTRIC DIPOLE MOMENTS' in j:
            k.append(i)
    l=k[0]
    k.pop(0)

    return NRoots, l, k, h

# Determine Absorption Spectra Data from orca.out file
def state_0(filename,root,line_s):
    """ Parses the GS to ES absorption data. """
    
    state_0=[]
    energy_0=[]
    energyev_0=[]
    wavelength_0=[]
    intensity_0=[]
    t2_0=[]
    tx_0=[]
    ty_0=[]
    tz_0=[]
    state_i=np.zeros(root)
    
    with open(filename, 'r') as f:
        for i in range(line_s+5):
            line=f.readline()
        for i in range(root):
            line=f.readline()
            state, energy, wavelength, intensity, t2, tx, ty, tz = [
                float(x) for x in line.split()
            ]
            energyev=convertor(energy, "wavenumber", "eV")
            energy=convertor(energy, "wavenumber", "hartree")
            state_0.append(state)
            energy_0.append(energy)
            energyev_0.append(energyev)
            wavelength_0.append(wavelength)
            intensity_0.append(intensity)
            t2_0.append(t2)
            tx_0.append(tx)
            ty_0.append(ty)
            tz_0.append(tz)
            
    return state_i, state_0, energy_0, energyev_0, wavelength_0, intensity_0, t2_0, tx_0, ty_0, tz_0

def tran_state(filename,root,line_s,root_s):
    """ Parses the Transient Absorption data. """
    
    state_t=[]
    energy_t=[]
    energyev_t=[]
    wavelength_t=[]
    intensity_t=[]
    t2_t=[]
    tx_t=[]
    ty_t=[]
    tz_t=[]
    state_i=np.full(root-root_s,root_s+.0)
    
    with open(filename) as f:
        for i in range(line_s+5):
            line=f.readline()
        for i in range(root_s+1, NRoots+1):
            line=f.readline()
            state, energy, wavelength, intensity, t2, tx, ty, tz = [
                float(x) for x in line.split()
            ]
            energyev=convertor(energy, 'wavenumber', "eV")
            energy=convertor(energy, "wavenumber", "hartree")
            state_t.append(state)
            energy_t.append(energy)
            energyev_t.append(energyev)
            wavelength_t.append(wavelength)
            intensity_t.append(intensity)
            t2_t.append(t2)
            tx_t.append(tx)
            ty_t.append(ty)
            tz_t.append(tz)
            
    return state_i, state_t, energy_t, energyev_t, wavelength_t, intensity_t, t2_t, tx_t, ty_t, tz_t

class OutputPresentError(Exception):
    """ Error that is probably already implemented but I don't know """
    
# Generates a matlab readable output file    
def matlab_output(filename,root,iroot,ifilename):
    """ Generates matlab readable output file with format:
        
    Initial_State Final_State Energy_eV Wavelength_nm OS_str D**2_au Dx_au Dy_au Dz_au """
 
    with open(filename, 'a') as f:
        if iroot == 0:
            istate, state, energy, energyev, wavelength, intensity, t2, tx, ty, tz = state_0(ifilename,NRoots,begin)
            for i in range(root):
                out=f' {istate[i]:5}  {state[i]:5}   {energy[i]:20}   {energyev[i]:20}   {wavelength[i]:7}   {intensity[i]:11}   {t2[i]:10}   {tx[i]:10}   {ty[i]:10}   {tz[i]:10}\n'
                f.writelines(out)
        else:
            istate, state, energy, energyev, wavelength, intensity, t2, tx, ty, tz = tran_state(ifilename,NRoots,begin_tr[iroot-1],iroot)
            for i in range(root-iroot):
                out=f' {istate[i]:5}  {state[i]:5}   {energy[i]:20}   {energyev[i]:20}   {wavelength[i]:7}   {intensity[i]:11}   {t2[i]:10}   {tx[i]:10}   {ty[i]:10}   {tz[i]:10}\n'
                f.writelines(out)

def mat_energy(root,iroot,ifilename):
    """ Generates matlab readable output file with format:
        
    Initial_State Final_State Energy_eV Wavelength_nm OS_str D**2_au Dx_au Dy_au Dz_au """

    EIG = [0]    
    istate, state, energy, energyev, wavelength, intensity, t2, tx, ty, tz = state_0(ifilename,NRoots,begin)
    #for i in range(root):
    EIG.extend(energy)

    return EIG

# Generate a matlab readable output file for eigenenergies
def matlab_energy(ifilename,ofilename,line_s):
    """ Generates a matlab readable output file with eigenenergies. """
    
    with open(ifilename, 'r') as f:
        with open(ofilename, 'w') as g:
            for i in range(line_s+4):
                line=f.readline()
            for i in range(10000):
                line=f.readline()
                if len(line.strip()) == 0:
                    break
                else:
                    band, occ, energy_Eh, energy_eV = [
                        float(x) for x in line.split()
                    ]
                    out=f' {energy_eV:10}\n'
                    g.writelines(out)
                
# Generates a numpy array of the transition dipole moments
def numpy_array(filename,root,iroot):
    """ Generate a numpy array with the transition dipole moments.
    
    First index (0=Dx, 1=Dy, 2=Dz, 3=D**2)
    Second index (initial state)
    Third index (final state (start counting from zero (ie 0=S_1))) """
    
    if iroot == 0:
        istate, state, energy, energyev, wavelength, intensity, t2, tx, ty, tz = state_0(filename,NRoots,begin)
        for i in range(root):
            Dij[0, 0, int(state[i])] = tx[i]
            Dij[0, int(state[i]), 0] = tx[i]
            Dij[1, 0, int(state[i]-1)] = ty[i]
            Dij[1, int(state[i]), 0] = ty[i]
            Dij[2, 0, int(state[i])] = tz[i]
            Dij[2, int(state[i]), 0] = tz[i]
            #Dij[3, 0, int(state[i]-1)] = t2[i]
    else:
        istate, state, energy, energyev, wavelength, intensity, t2, tx, ty, tz = tran_state(filename,NRoots,begin_tr[iroot-1],iroot)
        for i in range(root-iroot):
            Dij[0, int(istate[i]), int(state[i])] = tx[i]
            Dij[1, int(istate[i]), int(state[i])] = ty[i]
            Dij[2, int(istate[i]), int(state[i])] = tz[i]
            Dij[0, int(state[i]), int(istate[i])] = tx[i]
            Dij[1, int(state[i]), int(istate[i])] = ty[i]
            Dij[2, int(state[i]), int(istate[i])] = tz[i]
            #Dij[3, int(istate[i]), int(state[i]-1)] = t2[i]
            
np.set_printoptions(threshold=sys.maxsize, linewidth=300)


# Determine the input files
listdirc = os.listdir()
file = []
for i in listdirc:
    exten = os.path.splitext(i)[1]
    if exten == '.out':
        file.append(i)

# Generate the desired outputs
for a in file:    
    NRoots, begin, begin_tr, E_orb = number_of_roots(a)
# Generate a Matlab readable file with absorption spectra data
    name = os.path.splitext(a)[0]
    output = name + '.mlab'
    if os.path.isfile(output):
        os.remove(output)
        print(f'{output} will be replaced')
    else:
        print(f'{output} will be created')
    for b in range(NRoots):
        matlab_output(output, NRoots, b, a)
# Generate a numpy array with the Transition Dipole Moments
### First index (0=Dx, 1=Dy, 2=Dz, 3=D**2)
### Second index (initial state)
### Third index (final state (start counting from zero (ie 0=S_1)))
    Dij = np.zeros((3,NRoots+1,NRoots+1))
    output = name + '.npy'
    for b in range(NRoots):
        numpy_array(a,NRoots,b)
    with open(output, 'wb') as f:
        np.save(f, Dij)
# Generate a MAT-file with the transition dipole matrix and eigenenergies
    moutput = name + '.mat'
    mDij = np.transpose(Dij, (1, 2, 0))
    mEIG = mat_energy(NRoots, 0, a)
    mat = {'MU': mDij, 'EIG': mEIG}
    savemat(moutput, mat, long_field_names=True, oned_as='column')
# Generates a Matlab readable file with eigenenergies
    #output = name + '_e.mlab'
    #matlab_energy(a, output, E_orb) #Not actually required for calculation but I don't want to delete in case it becomes useful
        
print('HELLO FINISH')