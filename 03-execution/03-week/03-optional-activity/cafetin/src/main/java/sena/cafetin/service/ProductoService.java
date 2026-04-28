package sena.cafetin.service;

import sena.cafetin.entity.Producto;
import sena.cafetin.repository.ProductoRepository;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class ProductoService {
    private final ProductoRepository repo;
    public ProductoService(ProductoRepository repo) { this.repo = repo; }

    public List<Producto> findAll() { return repo.findAll(); }
    public Optional<Producto> findById(Long id) { return repo.findById(id); }
    public Producto save(Producto producto) { return repo.save(producto); }
    public void delete(Long id) { repo.deleteById(id); }
}