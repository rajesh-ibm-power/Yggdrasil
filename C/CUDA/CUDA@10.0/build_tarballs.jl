using BinaryBuilder

include("../../../fancy_toys.jl")

name = "CUDA"
version = v"10.0.130"

dependencies = [BuildDependency(PackageSpec(name="CUDA_full_jll", version=version))]

script = raw"""
# First, find (true) CUDA toolkit directory in ~/.artifacts somewhere
CUDA_ARTIFACT_DIR=$(dirname $(dirname $(realpath ${bindir}/ptxas${exeext})))
cd ${CUDA_ARTIFACT_DIR}

# Clear out our prefix
rm -rf ${prefix}

# license
install_license share/licenses/CUDA_full/*

# headers
mkdir -p ${prefix}/include
mv include/* ${prefix}/include
rm -rf ${prefix}/include/thrust

# binaries
mkdir -p ${bindir} ${libdir} ${prefix}/lib ${prefix}/share
if [[ ${target} == x86_64-linux-gnu ]]; then
    # CUDA Runtime
    mv lib64/libcudart.so* lib64/libcudadevrt.a ${libdir}

    # CUDA FFT Library
    mv lib64/libcufft.so* lib64/libcufftw.so* ${libdir}

    # CUDA BLAS Library
    mv lib64/libcublas.so* ${libdir}

    # NVIDIA "Drop-in" BLAS Library
    mv lib64/libnvblas.so* ${libdir}

    # CUDA Sparse Matrix Library
    mv lib64/libcusparse.so* ${libdir}

    # CUDA Linear Solver Library
    mv lib64/libcusolver.so* ${libdir}

    # CUDA Random Number Generation Library
    mv lib64/libcurand.so* ${libdir}

    # CUDA Accelerated Graph Library
    mv lib64/libnvgraph.so* ${libdir}

    # NVIDIA Performance Primitives Library
    mv lib64/libnpp*.so* ${libdir}

    # NVIDIA Optimizing Compiler Library
    mv nvvm/lib64/libnvvm.so* ${libdir}

    # NVIDIA Common Device Math Functions Library
    mkdir ${prefix}/share/libdevice
    mv nvvm/libdevice/libdevice.10.bc ${prefix}/share/libdevice

    # CUDA Profiling Tools Interface (CUPTI) Library
    mv extras/CUPTI/lib64/libcupti.so* ${libdir}

    # NVIDIA Tools Extension Library
    mv lib64/libnvToolsExt.so* ${libdir}

    # CUDA Disassembler
    mv bin/nvdisasm ${bindir}
elif [[ ${target} == x86_64-apple-darwin* ]]; then
    # CUDA Runtime
    mv lib/libcudart.*dylib lib/libcudadevrt.a ${libdir}

    # CUDA FFT Library
    mv lib/libcufft.*dylib lib/libcufftw.*dylib ${libdir}

    # CUDA BLAS Library
    mv lib/libcublas.*dylib ${libdir}

    # NVIDIA "Drop-in" BLAS Library
    mv lib/libnvblas.*dylib ${libdir}

    # CUDA Sparse Matrix Library
    mv lib/libcusparse.*dylib ${libdir}

    # CUDA Linear Solver Library
    mv lib/libcusolver.*dylib ${libdir}

    # CUDA Random Number Generation Library
    mv lib/libcurand.*dylib ${libdir}

    # CUDA Accelerated Graph Library
    mv lib/libnvgraph.*dylib ${libdir}

    # NVIDIA Performance Primitives Library
    mv lib/libnpp*.*dylib ${libdir}

    # NVIDIA Optimizing Compiler Library
    mv nvvm/lib/libnvvm.*dylib ${libdir}

    # NVIDIA Common Device Math Functions Library
    mkdir ${prefix}/share/libdevice
    mv nvvm/libdevice/libdevice.10.bc ${prefix}/share/libdevice

    # CUDA Profiling Tools Interface (CUPTI) Library
    mv extras/CUPTI/lib/libcupti.*dylib ${libdir}

    # NVIDIA Tools Extension Library
    mv lib/libnvToolsExt.*dylib ${libdir}

    # CUDA Disassembler
    mv bin/nvdisasm ${bindir}
elif [[ ${target} == x86_64-w64-mingw32 ]]; then
    # CUDA Runtime
    mv bin/cudart64_*.dll ${bindir}
    mv lib/x64/cudadevrt.lib ${prefix}/lib

    # CUDA FFT Library
    mv bin/cufft64_*.dll bin/cufftw64_*.dll ${bindir}

    # CUDA BLAS Library
    mv bin/cublas64_*.dll ${bindir}

    # NVIDIA "Drop-in" BLAS Library
    mv bin/nvblas64_*.dll ${bindir}

    # CUDA Sparse Matrix Library
    mv bin/cusparse64_*.dll ${bindir}

    # CUDA Linear Solver Library
    mv bin/cusolver64_*.dll ${bindir}

    # CUDA Random Number Generation Library
    mv bin/curand64_*.dll ${bindir}

    # CUDA Accelerated Graph Library
    mv bin/nvgraph64_*.dll ${bindir}

    # NVIDIA Performance Primitives Library
    mv bin/npp*64_*.dll ${bindir}

    # NVIDIA Optimizing Compiler Library
    mv nvvm/bin/nvvm64_*.dll ${bindir}

    # NVIDIA Common Device Math Functions Library
    mkdir ${prefix}/share/libdevice
    mv nvvm/libdevice/libdevice.10.bc ${prefix}/share/libdevice

    # CUDA Profiling Tools Interface (CUPTI) Library
    mv extras/CUPTI/libx64/cupti64_*.dll ${bindir}

    # NVIDIA Tools Extension Library
    mv bin/nvToolsExt64_1.dll ${bindir}

    # CUDA Disassembler
    mv bin/nvdisasm.exe ${bindir}
fi
"""

products = [
    LibraryProduct(["libcudart", "cudart64_100"], :libcudart),
    FileProduct(["lib/libcudadevrt.a", "lib/cudadevrt.lib"], :libcudadevrt),
    LibraryProduct(["libcufft", "cufft64_100"], :libcufft),
    LibraryProduct(["libcufftw", "cufftw64_100"], :libcufftw),
    LibraryProduct(["libcublas", "cublas64_100"], :libcublas),
    LibraryProduct(["libnvblas", "nvblas64_100"], :libnvblas),
    LibraryProduct(["libcusparse", "cusparse64_100"], :libcusparse),
    LibraryProduct(["libcusolver", "cusolver64_100"], :libcusolver),
    LibraryProduct(["libcurand", "curand64_100"], :libcurand),
    LibraryProduct(["libnvgraph", "nvgraph64_100"], :libcurand),
    LibraryProduct(["libnppc", "nppc64_100"], :libnppc),
    LibraryProduct(["libnppial", "nppial64_100"], :libnppial),
    LibraryProduct(["libnppicc", "nppicc64_100"], :libnppicc),
    LibraryProduct(["libnppicom", "nppicom64_100"], :libnppicom),
    LibraryProduct(["libnppidei", "nppidei64_100"], :libnppidei),
    LibraryProduct(["libnppif", "nppif64_100"], :libnppif),
    LibraryProduct(["libnppig", "nppig64_100"], :libnppig),
    LibraryProduct(["libnppim", "nppim64_100"], :libnppim),
    LibraryProduct(["libnppist", "nppist64_100"], :libnppist),
    LibraryProduct(["libnppisu", "nppisu64_100"], :libnppisu),
    LibraryProduct(["libnppitc", "nppitc64_100"], :libnppitc),
    LibraryProduct(["libnpps", "npps64_100"], :libnpps),
    LibraryProduct(["libnvvm", "nvvm64_33_0"], :libnvvm),
    FileProduct("share/libdevice/libdevice.10.bc", :libdevice),
    LibraryProduct(["libcupti", "cupti64_100"], :libcupti),
    LibraryProduct(["libnvToolsExt", "nvToolsExt64_1"], :libnvtoolsext),
    ExecutableProduct("nvdisasm", :nvdisasm),
]

build_tarballs(ARGS, name, version, [], script,
               [Linux(:x86_64), MacOS(:x86_64), Windows(:x86_64)], products, dependencies)