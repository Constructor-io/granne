use core::mem;
use std::alloc::{alloc, Layout};
use std::io::{Result, Write};
use std::ptr;

/// Loads a slice of bytes as a slice of type T
pub unsafe fn load_bytes_as<T>(bytes: &[u8]) -> &[T] {
    let curr_ptr = bytes.as_ptr();
    let align_of = mem::align_of::<T>();
    let not_aligned = curr_ptr as usize % align_of != 0;

    let ptr = if not_aligned {
        let layout = Layout::from_size_align(bytes.len(), align_of).unwrap();
        let new_ptr = alloc(layout);
        ptr::copy_nonoverlapping(curr_ptr, new_ptr, bytes.len());
        new_ptr
    } else {
        curr_ptr
    };

    let elements: &[T] = ::std::slice::from_raw_parts(ptr as *const T, bytes.len() / ::std::mem::size_of::<T>());

    elements
}

pub fn write_as_bytes<T, B: Write>(elements: &[T], buffer: &mut B) -> Result<usize> {
    let size = elements.len() * ::std::mem::size_of::<T>();
    let data = unsafe { ::std::slice::from_raw_parts(elements.as_ptr() as *const u8, size) };

    buffer.write_all(data)?;

    Ok(size)
}

/// A trait for types that are writeable to a buffer
pub trait Writeable {
    /// Writes `self` to `buffer`, if successful returns `Ok(num_bytes_written)`
    fn write<B: Write>(self: &Self, buffer: &mut B) -> Result<usize>;
}
