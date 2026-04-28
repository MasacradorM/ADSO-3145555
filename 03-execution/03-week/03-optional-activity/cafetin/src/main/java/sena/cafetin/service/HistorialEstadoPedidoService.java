package sena.cafetin.service;

import sena.cafetin.entity.HistorialEstadoPedido;
import sena.cafetin.repository.HistorialEstadoPedidoRepository;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class HistorialEstadoPedidoService {
    private final HistorialEstadoPedidoRepository repo;
    public HistorialEstadoPedidoService(HistorialEstadoPedidoRepository repo) { this.repo = repo; }

    public List<HistorialEstadoPedido> findAll() { return repo.findAll(); }
    public Optional<HistorialEstadoPedido> findById(Long id) { return repo.findById(id); }
    public HistorialEstadoPedido save(HistorialEstadoPedido historial) { return repo.save(historial); }
    public void delete(Long id) { repo.deleteById(id); }
}