package sena.cafetin.service;

import sena.cafetin.entity.DetallePedido;
import sena.cafetin.repository.DetallePedidoRepository;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class DetallePedidoService {
    private final DetallePedidoRepository repo;
    public DetallePedidoService(DetallePedidoRepository repo) { this.repo = repo; }

    public List<DetallePedido> findAll() { return repo.findAll(); }
    public Optional<DetallePedido> findById(Long id) { return repo.findById(id); }
    public DetallePedido save(DetallePedido detalle) { return repo.save(detalle); }
    public void delete(Long id) { repo.deleteById(id); }
}