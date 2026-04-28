package sena.cafetin.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "historial_estado_pedido")
public class HistorialEstadoPedido {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "pedido_id", nullable = false)
    private Pedido pedido;

    @ManyToOne
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @Enumerated(EnumType.STRING)
    @Column(name = "estado_anterior")
    private EstadoPedido estadoAnterior;

    @Enumerated(EnumType.STRING)
    @Column(name = "estado_nuevo", nullable = false)
    private EstadoPedido estadoNuevo;

    private String observacion;

    @Column(name = "cambiado_en")
    private LocalDateTime cambiadoEn = LocalDateTime.now();

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Pedido getPedido() { return pedido; }
    public void setPedido(Pedido pedido) { this.pedido = pedido; }
    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }
    public EstadoPedido getEstadoAnterior() { return estadoAnterior; }
    public void setEstadoAnterior(EstadoPedido estadoAnterior) { this.estadoAnterior = estadoAnterior; }
    public EstadoPedido getEstadoNuevo() { return estadoNuevo; }
    public void setEstadoNuevo(EstadoPedido estadoNuevo) { this.estadoNuevo = estadoNuevo; }
    public String getObservacion() { return observacion; }
    public void setObservacion(String observacion) { this.observacion = observacion; }
    public LocalDateTime getCambiadoEn() { return cambiadoEn; }
    public void setCambiadoEn(LocalDateTime cambiadoEn) { this.cambiadoEn = cambiadoEn; }
}