package sena.cafetin.service;

import sena.cafetin.entity.Pedido;
import sena.cafetin.repository.PedidoRepository;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class PedidoService {
    private final PedidoRepository repo;
    public PedidoService(PedidoRepository repo) { this.repo = repo; }

    public List<Pedido> findAll() { return repo.findAll(); }
    public Optional<Pedido> findById(Long id) { return repo.findById(id); }
    public Pedido save(Pedido pedido) { return repo.save(pedido); }
    public void delete(Long id) { repo.deleteById(id); }
}